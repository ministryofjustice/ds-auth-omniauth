module DsAuth
  module Omniauth
    class User
      attr_reader :uid, :email, :name, :phone, :mobile,
        :full_address, :postcode, :organisations

      def self.build_from(auth_hash)
        user = auth_hash.fetch("user")
        new(
          uid:   user.fetch("uid"),
          name:  user.fetch("name"),
          email: user.fetch("email"),
          phone: user.fetch("telephone"),
          mobile: user.fetch("mobile"),
          full_address: user.fetch("address").fetch("full_address"),
          postcode: user.fetch("address").fetch("postcode"),
          organisations: Array(user.fetch("organisations"))
        )
      end

      def initialize(uid:, name:, email:, phone: "", mobile: "", full_address: "", postcode: "", organisations: [])
        @uid   = uid
        @name  = name
        @email = email
        @phone = phone
        @mobile = mobile
        @full_address = full_address
        @postcode = postcode
        @organisations = organisations
      end
    end
  end
end


