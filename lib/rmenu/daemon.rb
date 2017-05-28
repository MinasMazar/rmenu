module Rmenu
  class Daemon < Instance
    attr_accessor :listening
    attr_accessor :listening_thread

    def start
      self.listening = true
      self.listening_thread = Thread.new do
        LOGGER.info "Created listening thread.. wait for wake code at #{context[:waker_io]}.."
        while self.listening && keep_open? || (wake_code = File.read(waker_io).chomp).to_sym
          wake! wake_code
        end
      end
      self
    end

    def wake!(wake_code)
      proc
    end

    def proc
      result = super
      return unless result
      keep_open! if result[:keep_open] || result[:item] && result[:item][:keep_open]
      context
    end

    def stop
      super
      self.listening = false
      LOGGER.info "Stopping listening thread"
      listening_thread && listening_thread.kill
      self
    end

    def load_config(c_file = self.config_file)
      self.config = super c_file
    end
    alias :l :load_config

    def save_config(c_file = self.config_file)
      super c_file
    end
    alias :sav :save_config
    alias :s :save_config

    def keep_open!
      context[:keep_open] = true
    end
    alias :ko! :keep_open!

    def keep_open?
      context[:keep_open]
    end

    def keep_close!
      context[:keep_open] = false
    end
    alias :kc! :keep_close!
  end
end
