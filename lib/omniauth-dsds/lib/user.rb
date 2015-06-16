module Omniauth
  module Dsds
    class User
      attr_reader :uid, :email, :name, :organisations

      def self.build_from(auth_hash)
        user = auth_hash.fetch("user")
        new(
          uid:   user.fetch("uid"),
          name:  user.fetch("name"),
          email: user.fetch("email"),
          organisations: Array(user.fetch("organisations"))
        )
      end

      def initialize(uid:, name:, email:, organisations:)
        @uid   = uid
        @name  = name
        @email = email
        @organisations = organisations
      end
    end
  end
end


