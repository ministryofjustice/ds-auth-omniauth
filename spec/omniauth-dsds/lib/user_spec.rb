require "spec_helper"
require_relative "../../../lib/omniauth-dsds/lib/user"
require "omniauth"

RSpec.describe Omniauth::Dsds::User, ".build_from" do
  it "builds a user from the auth hash" do
    auth_hash = {
      "user" => {
          "email" => "bob.smith@world.com",
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
          "organisation_uids" => ['UID1', 'UID2'],
          "uid"   => "12345678-abcd-1234-abcd-1234567890"
      },
      "roles" => [
          "admin", "foo", "bar"
      ]
    }

    user = Omniauth::Dsds::User.build_from auth_hash

    expect(user.uid).to   eq "12345678-abcd-1234-abcd-1234567890"
    expect(user.name).to  eq "Bob Smith"
    expect(user.email).to eq "bob.smith@world.com"
    expect(user.roles).to eq ["admin", "foo", "bar"]
    expect(user.organisation_uids).to eq ["UID1", "UID2"]
  end
end
