require "spec_helper"
require_relative "../../../lib/omniauth-dsds/lib/user"
require "omniauth"

RSpec.describe Omniauth::Dsds::User, ".build_from" do
  it "builds a user from the auth hash" do
    auth_hash = {
      "user" => {
          "id"    => 1,
          "email" => "bob.smith@world.com",
          "uid"   => "12345678-abcd-1234-abcd-1234567890"
      },
      "profile" => {
          "name"      => "Bob Smith",
          "email"     => "bob.smith@world.com",
          "telephone" => "0123456789",
          "mobile"    => "071234567",
          "address"   => {
              "line1"    => "",
              "line2"    => "",
              "city"     => "",
              "postcode" => ""
          },
          "PIN"              => "1234",
          "organisation_ids" => [1,2]
      },
      "roles" => [
          "admin", "foo", "bar"
      ]
    }

    user = Omniauth::Dsds::User.build_from auth_hash

    expect(user.uid).to   eq "12345678-abcd-1234-abcd-1234567890"
    expect(user.name).to  eq "Bob Smith"
    expect(user.email).to eq "bob.smith@world.com"
  end
end
