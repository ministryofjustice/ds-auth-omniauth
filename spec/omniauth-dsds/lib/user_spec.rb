require "spec_helper"
require_relative "../../../lib/omniauth-dsds/lib/user"
require "omniauth"

RSpec.describe Omniauth::Dsds::User, ".build_from" do
  it "builds a user from the auth hash" do
    organisation_1 = {
        "uuid" => "CUSTODY-SUITE-UID",
        "name" => "Custody Suite London",
        "type" => "custody_suite",
        "roles" => ["cso", "admin"]
    }
    organisation_2 = {
        "uuid" => "LAW-FIRM-UID",
        "name" => "Law Firm Blecthley",
        "type" => "law_firm",
        "roles" => ["solicitor"]
    }
    auth_hash = {
      "user" => {
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
          "organisations" => [ organisation_1, organisation_2 ],
          "uid"   => "12345678-abcd-1234-abcd-1234567890"
      }
    }

    user = Omniauth::Dsds::User.build_from auth_hash

    expect(user.uid).to   eq "12345678-abcd-1234-abcd-1234567890"
    expect(user.name).to  eq "Bob Smith"
    expect(user.email).to eq "bob.smith@world.com"
    expect(user.organisations).to match_array([organisation_1, organisation_2])
  end
end
