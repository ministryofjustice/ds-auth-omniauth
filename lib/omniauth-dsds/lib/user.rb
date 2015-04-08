module Omniauth
  module Dsds
    class User
      attr_reader :uid, :email, :name

      def self.build_from(auth_hash)
        new(
          auth_hash.fetch("user").fetch("id")
        )
      end

      def initialize(uid)
        @uid = uid
      end
    end
  end
end


