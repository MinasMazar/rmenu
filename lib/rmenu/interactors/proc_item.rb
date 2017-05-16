module Rmenu
  module Interactors
    class ProcItem
      include Interactor

      before :validate_context!

      def call
        item = context.item
        proc_array item[:cmd] if item[:cmd].is_a? Array
        proc_string item[:cmd] if item[:cmd].is_a? String
      end

      private

      def proc_array(submenu)
        context.back = context.menu
        context.submenu = submenu
      end

      def proc_string(cmd)
        return if cmd.nil? || cmd == ''
        if md = cmd.match(/^\s*:\s*(.+)/)
          context.eval_cmd = md[1].strip
        elsif md = cmd.match(/^\s*(http:\/\/.+)/)
          context.url = md[1]
        elsif md = cmd.match(/\s*\+\s*(.+)/)
          context.save_item = { label: md[1].capitalize, cmd: md[1] }
        else
          context.shell_cmd = cmd
        end
      end

      def validate_context!
        context.fail! if context.item.nil?
      end
    end
  end
end