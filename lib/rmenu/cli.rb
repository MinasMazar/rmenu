require 'thor'

module Rmenu
  class CLI < Thor

    no_commands do

      def config
        @config ||= { lines: 11, items: items }
      end

      def items
        @items = STDIN.readlines
      end

      def rmenu_daemon
        Rmenu::Daemon.new config
      end

      def rmenu_instance
        Rmenu::Dmenu::Wrapper.new config
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
      rmenu_daemon.listening_thread.join
    rescue Interrupt
      puts "Interrupt catched.. exiting"
    end
  end
end
