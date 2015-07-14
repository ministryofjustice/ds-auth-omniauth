require "spec_helper"
require_relative "../../../lib/ds-auth-omniauth/lib/user"
require "omniauth"

RSpec.describe DsAuth::Omniauth::User, ".build_from" do
  it "builds a user from the auth hash" do
    organisation_1 = {
        "uid" => "CUSTODY-SUITE-UID",
        "name" => "Custody Suite London",
        "roles" => ["user", "admin"]
    }
    organisation_2 = {
        "uid" => "LAW-FIRM-UID",
        "name" => "Law Firm Blecthley",
        "roles" => ["viewer"]
    }
    auth_hash = {
      "user" => {
          "name"      => "Bob Smith",
          "email"     => "bob.smith@world.com",
          "telephone" => "0123456789",
          "mobile"    => "071234567",
          "address"   => {
              "full_address" => "1 Fake Street",
              "postcode" => "AB1 2CD"
          },
          "organisations" => [ organisation_1, organisation_2 ],
          "uid"   => "12345678-abcd-1234-abcd-1234567890"
      }
    }

    user = DsAuth::Omniauth::User.build_from auth_hash

    expect(user.uid).to    eq "12345678-abcd-1234-abcd-1234567890"
    expect(user.name).to   eq "Bob Smith"
    expect(user.email).to  eq "bob.smith@world.com"
    expect(user.phone).to  eq "0123456789"
    expect(user.mobile).to eq "071234567"
    expect(user.organisations).to match_array([organisation_1, organisation_2])
  end
end
