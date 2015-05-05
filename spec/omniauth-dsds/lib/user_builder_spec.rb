require "spec_helper"
require_relative "../../../lib/omniauth-dsds/lib/user"
require_relative "../../../lib/omniauth-dsds/lib/user_builder"
require "omniauth"

RSpec.describe Omniauth::Dsds::UserBuilder, "#build_user" do
  subject {
    Omniauth::Dsds::UserBuilder.new(
      app_id: app_id, app_secret: app_secret, token: token
    )
  }
  let(:app_id) { "12345" }
  let(:app_secret) { "ABCDE" }
  let(:token) { "ZXCVB" }

  context "with a blank token" do
    let(:token) { nil }

    it "returns nil" do
      expect(subject.build_user).to be_nil
    end
  end

  before do
    allow(subject).to receive(:fetch_raw_info).with(token).and_return raw_info_response
  end

  let(:roles) { ['cso'] }
  let(:raw_info_response) { { "roles" => roles } }

  context "when raw_info has no roles" do
    let(:roles) { [] }

    it "returns nil" do
      expect(subject.build_user).to be_nil
    end
  end

  context "when raw_info has roles" do
    it "returns a new User object" do
      stub_user = double("User")
      expect(Omniauth::Dsds::User).to receive(:build_from).with(raw_info_response).and_return stub_user

      expect(subject.build_user).to eq stub_user
    end
  end
end
