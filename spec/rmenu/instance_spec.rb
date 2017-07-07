require "spec_helper"

RSpec.describe Rmenu::Instance do
  let(:described_instance) { described_class.new config}
  let(:config) { { config_file: RSpec.configuration.history_file } }
  let(:pipe) { spy }
  let(:item) { nil }
  before do
    allow(IO).to receive(:popen).and_return pipe
    allow(pipe).to receive(:read).and_return item
    allow(Rake).to receive(:sh)
  end

  describe "#proc" do
    context 'dmenu returned a special command to be evaluated' do
      subject { described_instance.proc }
      let(:item) { ': context[:parameter] = 3' }
      before { subject }

      it 'evaultate command' do
        expect(Rake).not_to have_received(:sh)
        expect(subject[:parameter]).to be == 3
      end
    end
  end
end
