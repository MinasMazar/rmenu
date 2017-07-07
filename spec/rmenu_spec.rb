require "spec_helper"

RSpec.describe Rmenu do
  it "has a version number" do
    expect(Rmenu::VERSION).not_to be nil
  end

  it "has a dmenu wrapper class" do
    expect(defined?(Rmenu::Wrapper::Dmenu)).to be_truthy
  end
end
