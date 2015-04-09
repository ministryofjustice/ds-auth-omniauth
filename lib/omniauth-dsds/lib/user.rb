module Omniauth
  module Dsds
    class User
      attr_reader :uid, :email, :name

      def self.build_from(auth_hash)
        new(
          uid:   auth_hash.fetch("user").fetch("uid"),
          name:  auth_hash.fetch("profile").fetch("name"),
          email: auth_hash.fetch("profile").fetch("email")
        )
      end

      def initialize(uid:, name:, email:)
        @uid   = uid
        @name  = name
        @email = email
      end
    end
  end
end


