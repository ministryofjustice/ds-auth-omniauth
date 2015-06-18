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
              "name" => options.fetch(:name) { "Bob Smith" },
              "email" => options.fetch(:email) { "bob.smith@world.com" },
              "telephone" => options.fetch(:telephone) { "0123456789" },
              "mobile" => options.fetch(:mobile) { "071234567" },
              "address" => {
                "full_address" => options.fetch(:full_address) { "" },
                "postcode" => options.fetch(:postcode) { "" }
              },
              "PIN" => options.fetch(:pin) { "1234" },
              "organisations" => options.fetch(:organisations) do
                [
                    {
                        "uid" => "12345678-bcde-1234-abcd-1234567890",
                        "name" => "SOME ORGANISATION",
                        "type" => options.fetch(:organisation_type) { "custody_suite" },
                        "roles" => %w(admin foo bar)
                    }
                ]
              end,
              "uid" =>  options.fetch(:uid) { "12345678-abcd-1234-abcd-1234567890" }
            }
          }.to_json

          WebMock.stub_request(:get, authentication_site_url+'/api/v1/me').
            to_return(status: 200, body: response_body, headers: {} )
        end
      end
    end
  end
end
