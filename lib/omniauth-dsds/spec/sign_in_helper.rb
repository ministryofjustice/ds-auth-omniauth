module Omniauth
  module Dsds
    module Spec
      module SignInHelper

        def mock_token(token: "ABCDEF")
          OmniAuth.config.test_mode = true

          OmniAuth.config.mock_auth[:defence_request] = OmniAuth::AuthHash.new({
            provider: "defence_request",
            uid: "12345678-abcd-1234-abcd-1234567890",
            credentials: {
              token: token,
            }
          })
        end

        def mock_profile(options: {}, authentication_site_url: "http://app.example.com")
          response_body = {
            "user" => {
              "email" => "bob.smith@world.com",
            },
            "profile" => {
              "name" => options.fetch(:name) { "Bob Smith" },
              "email" => options.fetch(:email) { "bob.smith@world.com" },
              "telephone" => options.fetch(:telephone) { "0123456789" },
              "mobile" => options.fetch(:mobile) { "071234567" },
              "address" => {
                "full_address" => options.fetch(:full_address) { "" },
                "postcode" => options.fetch(:postcode) { "" }
              },
              "PIN" => options.fetch(:pin) { "1234" },
              "organisation_uids" => options.fetch(:organisation_uids) { ["12345678-bcde-1234-abcd-1234567890","12345678-cdef-1234-abcd-1234567890"] },
              "uid" =>  options.fetch(:uid) { "12345678-abcd-1234-abcd-1234567890" }
            },
            "roles" => options.fetch(:roles) { ["admin", "foo", "bar"] }
          }.to_json

          WebMock.stub_request(:get, authentication_site_url+'/api/v1/profiles/me').
            to_return(status: 200, body: response_body, headers: {} )
        end
      end
    end
  end
end
