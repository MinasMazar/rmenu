require "rmenu/menu_helper"
require "rmenu/wrapper/dmenu"
require "rmenu/wrapper/labelled_dmenu"
require "rake"

module Rmenu
  class Instance
    include MenuHelper

    attr_accessor :config_file
    attr_accessor :waker_io
    attr_writer   :config

    def initialize(config = {})
      @config_file = config.delete :config_file
      @waker_io = config[:waker_io]
      @config = config
      self.config.merge! load_config config_file
      context[:menu] = history
    end

    def start
      proc '::single_instance'
    end

    def stop
      save_config if config[:save_on_quit]
    end

    def proc
      item = rmenu.gets
      result = Interactors::ProcItem.call context.merge({
        history: history.dup,
        item: item
      })
      instance_eval result.eval_cmd if result.eval_cmd
      exec_cmd result.shell_cmd if result.shell_cmd
      open_url result.url if result.url
      if result.save_item
        config[:history] << result.save_item
        LOGGER.info "Added #{result.save_item} to history"
        save_config config_file
      end
      if result[:submenu]
        context[:back] = context[:menu]
        context[:menu] = result[:submenu]
        proc
        back! if result[:go_back]
      end
      back! if result[:go_back]
      context
    rescue
      LOGGER.debug "#{$!.class} catched."
      LOGGER.debug $!.message
      LOGGER.debug $!.backtrace.join("\n")
      false
    end

    def config
      @config ||= {}
    end

    alias :context :config

    def menu
      context[:menu] ||= history
    end

    def history
      config[:history] ||= []
    end

    def back!
      LOGGER.info "Going to back menu"
      context[:menu] = context[:back] || history
    end

    def rmenu_params
      context.merge({
        items: insert_separator(evaluated_menu(menu)),
        prompt: eval_block(context[:prompt])
      })
    end

    def rmenu(menu = :history)
      Wrapper::LabelledDmenu.new rmenu_params
    end

    def load_config(config_file)
      if config_file && File.exist?(config_file)
        _config = YAML.load_file config_file
        LOGGER.info "Loaded config from #{config_file}"
        _config ||= {}
      end
    end

    def save_config(config_file)
      raise "Unable to save config file: #{config_file}" unless config_file
      File.write config_file, YAML.dump(config.to_h)
      LOGGER.info "Saved config at #{config_file}"
    end

    def exec_cmd cmd
      exec_with_log do
        spawn_cmd eval_block cmd.strip
      end
    end

    def open_url url
      exec_with_log "Opening url with command" do
        spawn_cmd "#{context[:web_browser] || 'firefox'} \"#{url}\""
      end
    end

    def edit file
      exec_with_log "Editing file with command" do
        spawn_cmd "#{context[:editor]} \"#{file}\""
      end
    end

    private

    def exec_with_log(message = "Executing shell command:" )
      cmd = yield
      LOGGER.info "#{message} #{cmd}"
      Rake.sh cmd
    end

    def spawn_cmd cmd
      "#{cmd} &"
    end

    def eval_block(cmd)
      replaced_cmd = cmd.to_s
      while md = replaced_cmd.match(/(\{([^\{\}]+?)\})/)
        break unless md[1] || md[2]
        evaluated_string = instance_eval(md[2]).to_s # TODO: better to eval in a useful sandbox
        return if evaluated_string == nil
        replaced_cmd = replaced_cmd.sub(md[0], evaluated_string)
      end
      LOGGER.debug "Command interpolated with eval blocks: #{replaced_cmd}" if replaced_cmd != cmd
      replaced_cmd
    rescue Exception
      LOGGER.debug "Exception when interplating blocks: #{replaced_cmd}"
      LOGGER.debug $!.message
      cmd
    end

  end
end
