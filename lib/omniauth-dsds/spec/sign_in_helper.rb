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
                "name" => "Bob Smith",
                "email" => "bob.smith@world.com",
                "telephone" => "0123456789",
                "mobile" => "071234567",
                "address" => {
                    "line1" => "",
                    "line2" => "",
                    "city" => "",
                    "postcode" => ""
                },
                "PIN" => "1234",
                "organisation_ids" => [1,2],
                "uid" =>  options.fetch(:uid) { "12345678-abcd-1234-abcd-1234567890" }
            },
            "roles" => options.fetch(:roles) { ["admin", "foo", "bar"] }
          }.to_json

          WebMock.stub_request(:get, authentication_site_url+'/api/v1/me').
            to_return(status: 200, body: response_body, headers: {} )
        end
      end
    end
  end
end
