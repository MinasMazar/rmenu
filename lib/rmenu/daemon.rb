module Rmenu
  class Daemon < Instance
    attr_accessor :listening
    attr_accessor :listening_thread

    def initialize(config = {})
      super config
      context[:keep_open] ||= 0
    end

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

    def proc(item = nil)
      context[:keep_open] -= 1
      context[:keep_open] = 0 if context[:keep_open] < 0
      super item
      keep_open! context[:item] && context[:item][:keep_open]
      context
    end

    def stop
      super
      self.listening = false
      LOGGER.info "Stopping listening thread"
      listening_thread && listening_thread.kill
      self
    end

    def menu
      super.sort_by { |item| - item[:picked] || 0 }
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

    def keep_open!(sum = 1)
      context[:keep_open] = context[:keep_open].to_i + sum.to_i
    end
    alias :ko! :keep_open!

    def keep_open?
      context[:keep_open] > 0
    end

    def keep_close!
      context[:keep_open] = 0
    end
    alias :kc! :keep_close!
  end
end
