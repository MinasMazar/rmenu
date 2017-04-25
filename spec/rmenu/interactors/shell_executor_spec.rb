require "spec_helper"

RSpec.describe Rmenu::Interactors::ShellExecutor do
  subject { described_class.included_modules }
  it { is_expected.to be_include Interactor }
end
