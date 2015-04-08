require "spec_helper"
require_relative "../../../lib/omniauth-dsds/lib/user"
require "omniauth"

RSpec.describe Omniauth::Dsds::User, ".build_from" do
  it "builds a user from the auth hash" do
    auth_hash = {
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
    }

    user = Omniauth::Dsds::User.build_from auth_hash

    expect(user.uid).to eq 1
  end
end
