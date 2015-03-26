require "spec_helper"

describe OmniAuth::Strategies::Dsds do
  it "should have the correct name" do
    strategy = OmniAuth::Strategies::Dsds.new({})

    expect(strategy.options.name).to eq "dsds"
  end
end
