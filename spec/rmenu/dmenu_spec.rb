require "spec_helper"

RSpec.describe Rmenu::Dmenu do
  subject { described_class.new config }
  let(:config) { {} }

  it { is_expected.to be_an_instance_of Rmenu::Dmenu::Wrapper }
end
