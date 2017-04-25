module Rmenu
  module Interactors
    class ShellExecutor
      include Interactor

      before :spawn_cmd

      def call
        if context.success?
          LOGGER.debug "Executing command <#{context.cmd}>"
          system context.cmd
        end
      end

      private

      def spawn_cmd
        context.fail! if context.cmd.nil? || context.cmd.eql?('')
        context.cmd = "#{context.cmd} &"
      end
    end
  end
end
