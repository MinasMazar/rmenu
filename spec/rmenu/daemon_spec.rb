require "spec_helper"

RSpec.describe Rmenu::Daemon do
  include Rmenu::Test::Helpers

  subject { described_instance }
  let(:described_instance) { Rmenu::Daemon.new config}
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

  describe "Pick-counter mechanism" do
    subject { described_instance.menu }
    let(:menu) { [] }
    before do
      described_instance.instance_variable_set('@config', {
        history: menu
      })
    end

    context 'when menu has progressive picking' do
      let(:menu) { menu_with_progressive_pick_counter }

      it { is_expected.to be_an_instance_of Array }
      it { is_expected.to eql menu.reverse }
    end

    context 'when menu has reverse picking' do
      let(:menu) { menu_with_reverse_pick_counter }

      it { is_expected.to be_an_instance_of Array }
      it { is_expected.to eql menu }
    end
  end
end
