require "spec_helper"

RSpec.describe Rmenu::Daemon do
  include Rmenu::Test::Helpers

  let(:described_instance) { described_class.new config}
  let(:config) { { config_file: RSpec.configuration.history_file } }
  before { create_history_file }

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

  describe "#proc" do
    pending
  end
end
