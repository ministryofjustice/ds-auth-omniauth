module Omniauth
  module Dsds
    module Spec
      module SignInHelper

        def mock_token(token: "ABCDEF")
          OmniAuth.config.test_mode = true

          OmniAuth.config.mock_auth[:defence_request] = OmniAuth::AuthHash.new({
            provider: "defence_request",
            uid: "123456789",
            credentials: {
              token: token,
            }
          })
        end

        def mock_profile(token: "ABCDEF", profile: {}, authentication_site_url: "http://app.example.com")

          response_body = profile.reverse_merge({
            "user" => {
                "id" => 1,
                "first_name" => "Bob",
                "last_name" => "Smith",
                "username" => "bob.smith",
                "email" => "bob.smith@world.com"
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
                "organisation_ids" => [1,2]
            },
            "roles" => [
                "admin", "foo", "bar"
            ]
          }).to_json

          WebMock.stub_request(:get, authentication_site_url+'/api/v1/me').
            to_return(status: 200, body: response_body, headers: {} )
        end
      end
    end
  end
end