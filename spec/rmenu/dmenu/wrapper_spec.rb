require "spec_helper"

RSpec.describe Rmenu::Dmenu::Wrapper do
  let(:described_instance) { described_class.new config}
  let(:command) { nil }
  let(:config) { { items: items } }
  let(:items) { [] }
  let(:pipe) { spy }

  before do
    allow(IO).to receive(:popen).and_return(pipe)
    allow(pipe).to receive(:read).and_return("item1\n")
    described_instance.run
  end

  describe "items setup" do
    subject { described_instance }
    context "with no items" do
      it { expect(pipe).not_to have_received(:puts) }
    end
    context "with one item" do
      let(:items) { [ 'label1' ] }
      it { expect(pipe).to have_received(:puts).once }
    end
    context "with two items" do
      let(:items) { [ 'label1', 'label2' ] }
      it { expect(pipe).to have_received(:puts).twice }
    end
    context "with n items" do
      let(:items) { (1..11).map { |i| "label#{i}" } }
      it { expect(pipe).to have_received(:puts).exactly(11).times }
    end
  end

  describe "#gets" do
    subject { described_instance.run }
    it { expect(pipe).to have_received(:read) }
    it { is_expected.to eql 'item1' }
  end
end
