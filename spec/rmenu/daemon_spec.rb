require "spec_helper"

RSpec.describe Rmenu::Daemon do
  let(:described_instance) { described_class.new config}
  let(:config) { {} }
  let(:pipe) { spy }
  let(:thread) { spy }
  before do
    allow(Thread).to receive(:new).and_return(thread)
    allow(thread).to receive(:kill).and_return(true)
    allow(IO).to receive(:popen).and_return(pipe)
    allow(pipe).to receive(:read).and_return("item1\n")
  end

  it { expect(described_instance.dmenu_instance).to be_an_instance_of Rmenu::Dmenu::Wrapper }

  describe "#start" do
    before { described_instance.start }

    it { is_expected.to be_an_instance_of Rmenu::Daemon }
    it { expect(described_instance.listening).to be_truthy }
    it { expect(described_instance.listening_thread).not_to be_nil }
  end

  describe "#stop" do
    before { described_instance.stop }

    it { is_expected.to be_an_instance_of Rmenu::Daemon }
    it { expect(described_instance.listening).to be_falsey }
    it { expect(described_instance.listening_thread).to be_nil }
  end

  describe "#run" do
    subject { described_instance.run }

    it { is_expected.to be_an_instance_of String }
  end
end
