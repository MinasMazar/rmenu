require 'thor'

module Rmenu
  class CLI < Thor

    DEFAULT_WAKER_IO = File.expand_path(File.join("~", ".rmenu_waker"))

    no_commands do

      def config
        @config ||= { waker_io: DEFAULT_WAKER_IO, lines: 11, items: items }
      end

      def items
        @items = []
      end

      def rmenu_daemon
        @rmenu_daemon ||= Rmenu::Daemon.new config
      end

      def rmenu_instance
        @rmenu_instance||= Rmenu::Dmenu::Wrapper.new config
      end
    end

    desc "launch", "Launch dmenu in wrap mode"
    def launch
      puts rmenu_instance.gets
    end

    desc "start", "Start Rmenu in daemon mode"
    def start
      rmenu_daemon.start do |item|
        puts item
      end
      sleep 0.8
      rmenu_daemon.listening_thread.join
    rescue Interrupt
      puts "Interrupt catched.. exiting"
    end
  end
end
