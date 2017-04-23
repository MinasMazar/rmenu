
module Rmenu
  class Daemon
    attr_accessor :config
    attr_accessor :listening
    attr_accessor :listening_thread
    attr_accessor :keep_open


    def initialize(config = {})
      @config = config
    end

    def run
      dmenu_instance.run
    end

    alias :gets :run

    def start
      self.listening = true
      self.listening_thread = Thread.new do
        LOGGER.info "Created listening thread.. wait for wake code at #{conf[:waker_io]}.."
        while self.listening && keep_open? || (wake_code = File.read(conf[:waker_io]).chomp).to_sym
          item = gets
          proc item
        end
      end
      self
    end

    def stop
      self.listening = false
      LOGGER.info "Stopping listening thread"
      listening_thread && listening_thread.kill
      self
    end

    def dmenu_instance
      Dmenu::Wrapper.new config
    end
  end
end
