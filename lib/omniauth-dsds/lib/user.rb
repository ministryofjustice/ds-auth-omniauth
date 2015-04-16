module Omniauth
  module Dsds
    class User
      attr_reader :uid, :email, :name, :roles, :organisation_uids

      def self.build_from(auth_hash)
        profile = auth_hash.fetch("profile")
        new(
          uid:   profile.fetch("uid"),
          name:  profile.fetch("name"),
          email: profile.fetch("email"),
          roles: auth_hash.fetch("roles"),
          organisation_uids: profile.fetch("organisation_uids")
        )
      end

      def initialize(uid:, name:, email:, roles:, organisation_uids:)
        @uid   = uid
        @name  = name
        @email = email
        @roles = roles
        @organisation_uids = organisation_uids
      end
    end
  end
end


