require "spec_helper"
require_relative "../../../lib/ds-auth-omniauth/lib/user"
require_relative "../../../lib/ds-auth-omniauth/lib/user_builder"
require "omniauth"

RSpec.describe DsAuth::Omniauth::UserBuilder, "#build_user" do
  let(:builder) { DsAuth::Omniauth::UserBuilder.new(app_id: app_id, app_secret: app_secret, token: token) }
  let(:app_id) { "12345" }
  let(:app_secret) { "ABCDE" }
  let(:token) { "ZXCVB" }
  let(:roles) { ["cso"] }
  let(:raw_info_response) do
    {
      "user" => {
        "organisations" => [
          {
            "uid" => "UID1",
            "roles" => roles
          },
          {
            "uid" => "UID2"
          }
        ]
      }
    }
  end

  subject { builder.build_user }

  before do
    allow(builder).to receive(:fetch_raw_info).with(token).and_return raw_info_response
  end

  context "with a blank token" do
    let(:token) { nil }

    it { is_expected.to be nil }
  end

  context "with a non-blank token" do
    it "returns a new User object" do
      stub_user = double("User")
      expect(DsAuth::Omniauth::User).to receive(:build_from).with(raw_info_response).and_return stub_user

      is_expected.to eq stub_user
    end
  end
end
