require "spec_helper"
require "oauth2"
require_relative "../../../lib/omniauth-dsds/lib/controller_methods"

ENV['AUTHENTICATION_APPLICATION_ID'] = '12345'
ENV['AUTHENTICATION_APPLICATION_SECRET'] = 'abcfe'

RSpec.describe Omniauth::Dsds::ControllerMethods, "#current_user" do
  subject {
    Class.new do
      include Omniauth::Dsds::ControllerMethods

      def session
        @session ||= {}
      end

    end.new
  }

  context "with no auth token in the session" do
    it "returns nil" do
      expect(subject.current_user).to be_nil
    end
  end

  context "with an auth token in the session" do
    before do
      subject.session[:user_token] = "ABCDE"
    end

    let(:fake_user) { double("User") }

    it "uses the strategy to load the user profile" do
      expect(subject).to receive(:build_user).and_return fake_user
      expect(subject.current_user).to eq fake_user
    end

    context "when the user profile does not load" do
      before do
        # OAuth2::Error needs a Response object to be initialized ...
        fake_response = double("OAuth2::Response", :error= => nil, :parsed => nil, :body => '')
        expect(subject).to receive(:build_user).and_raise OAuth2::Error.new(fake_response)
      end

      it "clears the session" do
        subject.current_user
        expect(subject.session).to be_empty
      end

      it "returns nil" do
        expect(subject.current_user).to be_nil
      end
    end
  end
end
