module Omniauth
  module Dsds
    class User
      attr_reader :uid, :email, :name, :roles, :organisation_uids

      def self.build_from(auth_hash)
        user = auth_hash.fetch("user")
        new(
          uid:   user.fetch("uid"),
          name:  user.fetch("name"),
          email: user.fetch("email"),
          roles: Array(auth_hash.fetch("roles")),
          organisation_uids: Array(user.fetch("organisation_uids"))
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


