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
      allow(described_instance).to receive(:exec_cmd)
      init_context = described_instance.context
      allow(described_instance).to receive(:context).
        and_return(init_context.merge({
        menu: menu
      }))
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

    context 'when an item is picked 2 times (all starts from zero)' do
      let(:menu) { menu_with_zero_pick_counter }
      let!(:item) { menu.sample }
      before do
        2.times do
          described_instance.proc item
        end
      end

      it { expect(subject.first).to eql item }
    end
  end
end
