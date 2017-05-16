require "spec_helper"
require "rmenu/cli"

__END__

RSpec.describe Rmenu::CLI do
  describe "#launch" do
    let(:described_instance) { described_class.new }
    let(:argv) { %w(launch) }
    let(:rmenu) { spy }
    before do
      allow(Rmenu::Dmenu::Wrapper).to receive(:new).and_return(rmenu)
      allow(rmenu).to receive(:run).and_return 'item1'
      described_class.start argv
    end

    it { expect(rmenu).to have_received :run }
  end
end
