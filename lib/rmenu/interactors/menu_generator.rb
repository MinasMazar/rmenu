module Rmenu
  module Interactors
    class MenuGenerator
      include Interactor

      before :validate_context!

      def call
      end

      private

      def validate_context!
        context.fail! if context.menu.nil?
      end
    end
  end
end
