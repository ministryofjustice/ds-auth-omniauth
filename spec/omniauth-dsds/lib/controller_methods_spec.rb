require "spec_helper"
require "oauth2"
require_relative "../../../lib/omniauth-dsds/lib/user_builder"
require_relative "../../../lib/omniauth-dsds/lib/controller_methods"


ENV['AUTHENTICATION_APPLICATION_ID'] = '12345'
ENV['AUTHENTICATION_APPLICATION_SECRET'] = 'abcfe'

RSpec.describe Omniauth::Dsds::ControllerMethods do

  class FakeController
    def self.helper_method(included_method)
      @included_method = included_method
    end

    include Omniauth::Dsds::ControllerMethods

    def session
      @session ||= {}
    end

    def reset_session
      @session = {}
    end
  end

  subject { FakeController.new }

  describe "#authenticate_user!" do
    context "with current_user" do
      it "does not redirect" do
        allow(subject).to receive(:current_user).and_return double("User")
        expect(subject).not_to receive(:redirect_to)

        subject.send :authenticate_user!
      end
    end

    context "with no current_user" do
      it "redirects to login" do
        expect(subject).to receive(:current_user).and_return nil
        expect(subject).to receive(:redirect_to).with("/auth/defence_request")

        subject.send :authenticate_user!
      end
    end
  end

  describe "#current_user" do
    context "when the module is included" do
      it "adds the :current_user helper method" do
        expect(FakeController).to receive(:helper_method).with(:current_user)

        FakeController.send(:include, Omniauth::Dsds::ControllerMethods)
      end
    end

    context "with no auth token in the session" do
      it "returns nil" do
        expect(subject.current_user).to be_nil
      end
    end

    context "with an auth token in the session" do
      before do
        subject.session[:user_token] = access_token
        allow(user_builder).to receive(:build_user)
      end

      let(:access_token) { "ABCDE" }
      let(:fake_user) { double("User") }
      let(:user_builder) { double("UserBuilder") }

      it "initializes UserBuilder with the correct args" do
        expect(Omniauth::Dsds::UserBuilder).to receive(:new).with(
          hash_including(
            app_id: ENV['AUTHENTICATION_APPLICATION_ID'],
            app_secret: ENV['AUTHENTICATION_APPLICATION_SECRET'],
            token: access_token
          )
        ).and_return user_builder

        subject.current_user
      end

      it "uses the UserBuilder instance and access_token to load the user profile" do
        expect(Omniauth::Dsds::UserBuilder).to receive(:new).and_return user_builder
        expect(user_builder).to receive(:build_user).and_return fake_user

        expect(subject.current_user).to eq fake_user
      end

      context "when the user profile does not load" do
        before do
          expect(subject).to receive(:build_user).and_return nil
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
end
