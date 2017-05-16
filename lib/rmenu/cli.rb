require 'thor'

module Rmenu
  class CLI < Thor

    class_option :config,
      desc: "Config file",
      default: File.expand_path(File.join("~", ".rmenu.yml"))

    class_option :waker,
      desc: "IO/pipe where rmenu daemons waits for wake up codes",
      default: File.expand_path(File.join("~", ".rmenu_waker"))

    no_commands do

      def config
        { config_file: options[:config], waker_io: options[:waker] }
      end

      def read_items_from_stdin
        @items ||= STDIN.readlines
      end

      def rmenu_daemon
        @daemon ||= Rmenu::Daemon.new config
      end

      def rmenu_instance
        @instance ||= Rmenu::Instance.new config.merge items: read_items_from_stdin
      end
    end

    desc "launch", "Launch dmenu in wrap mode"
    def launch
      puts rmenu_instance.start
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
