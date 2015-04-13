module Omniauth
  module Dsds
    class User
      attr_reader :uid, :email, :name, :roles

      def self.build_from(auth_hash)
        new(
          uid:   auth_hash.fetch("user").fetch("uid"),
          name:  auth_hash.fetch("profile").fetch("name"),
          email: auth_hash.fetch("profile").fetch("email"),
          roles: auth_hash.fetch("roles")
        )
      end

      def initialize(uid:, name:, email:, roles:)
        @uid   = uid
        @name  = name
        @email = email
        @roles = roles
      end
    end
  end
end


