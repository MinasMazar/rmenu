module Rmenu
  module Dmenu
    class Wrapper

      def self.usage
        `dmenu --help 2>&1`.gsub(/(\n|\s)+/, " ")
      end

      attr_accessor :items
      attr_accessor :position
      attr_accessor :case_insensitive
      attr_accessor :lines
      attr_accessor :font
      attr_accessor :background
      attr_accessor :foreground
      attr_accessor :selected_background
      attr_accessor :selected_foreground
      attr_accessor :prompt
      attr_accessor :x, :y, :width

      def set_params(params = {})
        params.reject { |m| !respond_to? m }.each do |a, v|
          self.send "#{a}=", v
        end
        if block_given?
          instance_eval &Proc.new
        end
      end

      def initialize(params = {})
        @items               = []
        @position            = :top
        @case_insensitive    = false
        @lines               = 1
        @font                = nil
        @background          = nil
        @foreground          = nil
        @selected_background = nil
        @selected_foreground = nil
        @prompt              = nil
        @other_params        = ""
        set_params params
      end

      def items=(items)
        raise ArgumentError.new "Items array expected, got #{items.inspect}" unless items.kind_of? Array
        @items = items
      end

      def run
        #run__sys_call_impl
        run__pipe_impl
      end

      alias :gets :run

      private

      # Launches dmenu, displays the generated menu and waits for the user
      # to make a choice.
      #
      # @return [Item, nil] Returns the selected item or nil, if the user
      #   didn't make any selection (i.e. pressed ESC)
      def run__pipe_impl
        pipe = IO.popen(command, "w+")
        items.each do |item|
          pipe.puts item.to_s
        end

        pipe.close_write
        LOGGER.debug "PipeCommand> #{command}"
        value = pipe.read
        LOGGER.debug "PipeCommand< #{value}"
        pipe.close
        if $?.exitstatus > 0
          return nil
        end
        value.chomp
      end

      def run__sys_call_impl
        cmd = "echo -n \"#{items.join "\n"}\" | #{command.join " "} "
        value = `#{cmd}`
        LOGGER.debug  "Systemcall: #{cmd} => #{value}"
        value
      end

      def command
        args = ["dmenu"]

        if @position == :bottom
          args << "-b"
        end

        if @case_insensitive
          args << "-i"
        end

        @lines = @lines.to_i
        if @lines > 1
          args << "-l"
          args << lines.to_s
        end

        h = {
          "-fn" => @font,
          "-nb" => @background,
          "-nf" => @foreground,
          "-sb" => @selected_background,
          "-sf" => @selected_foreground,
          "-p"  => @prompt,
          "-x" => x,
          "-y" => y,
          "-w" => width,
        }

        h.each do |flag, value|
          value = value.to_s
          if value && !value.empty?
            args << flag
            args << value
          end
        end

        args << @other_params unless @other_params.empty?

        return args
      end
    end
  end
end
