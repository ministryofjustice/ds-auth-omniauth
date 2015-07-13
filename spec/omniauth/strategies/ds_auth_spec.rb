ENV['DS_AUTH_SITE_URL'] = 'https://example.com'
ENV['DS_AUTH_REDIRECT_URI'] = 'https://example.com/redirect_url'
ENV['DS_AUTH_RAW_INFO_PATH'] = "/api/v42/foobars"

require 'spec_helper'
require 'ds-auth-omniauth'

describe "ds_auth strategy" do
  subject do
    args = ['appid', 'secret', @options || {}].compact
    OmniAuth::Strategies::DsAuth.new(*args).tap do |strategy|
      allow(strategy).to receive(:request) {
        request
      }
    end
  end

  let(:request) { double('Request', :params => {}, :cookies => {}, :env => {}) }

  describe 'client options' do
    it 'should have correct name' do
      expect(subject.options.name).to eq('ds_auth')
    end

    it 'should have correct site pulled from the environment' do
      expect(subject.options.client_options.site).to eq('https://example.com')
    end

    it 'should have correct redirect url pulled from the environment' do
      expect(subject.options.client_options.redirect_url).to eq('https://example.com/redirect_url')
    end

    it 'should have correct raw_info_path pulled from the environment' do
      expect(subject.options.client_options.raw_info_path).to eq("/api/v42/foobars")
    end
  end

  describe "raw_info" do
    before do
      allow(fake_access_token).to receive(:get).and_return fake_response
      allow(fake_access_token).to receive(:token).and_return token
      allow(subject).to receive(:access_token).and_return fake_access_token
    end

    let(:token) { "sdljhfslfj" }
    let(:fake_access_token) { double("AccessToken") }
    let(:fake_response) { double("Response", body: "{\"fake\": \"response\"}") }

    it "uses the access_token to make a request to the user details url on the auth server" do
      expect(fake_access_token).to receive(:get).with(subject.options.client_options.raw_info_path).and_return fake_response
      subject.raw_info
    end

    it "returns the response parsed as json" do
      expect(subject.raw_info).to eq({"fake" => "response"})
    end

    context "when the ENV[\"OAUTH_DEBUG\"] flag is set" do
      it "prints the user details request as a curl command" do
        allow(ENV).to receive(:[]).with("DS_AUTH_DEBUG").and_return "true"
        expect(subject).to receive(:puts).with("\nhttps://example.com/api/v42/foobars result:")
        expect(subject).to receive(:pp).with({"fake" => "response"})
        expect(subject).to receive(:puts).with("curl -H \"Accept: application/json\" -H \"Authorization: Bearer #{token}\" https://example.com/api/v42/foobars\n\n")
        subject.raw_info
      end
    end

    context "when the ENV[\"OAUTH_DEBUG\"] flag is not set" do
      it "does not print user details request" do
        allow(ENV).to receive(:[]).with("DS_AUTH_DEBUG").and_return nil
        expect(subject).not_to receive(:log)
        subject.raw_info
      end
    end
  end
end
