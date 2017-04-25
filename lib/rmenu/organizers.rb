
module Rmenu
  module Organizers
    class Executor
      include Interactor::Organizer

      organize Interactors::ShellExecutor
    end
  end
end
