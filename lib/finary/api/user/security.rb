# frozen_string_literal: true

module Finary
  module User
    # Security entry contained in a Account and linked
    # to a Security
    class Security < Dry::Struct
      attribute :id, Types::Integer

      attribute :quantity, Types::Float.optional
      attribute :current_value, Types::Float.optional
      attribute :unrealized_pnl, Types::RoundedFloat.optional
      attribute :unrealized_pnl_percent, Types::RoundedFloat.optional
      attribute :buying_price, Types::RoundedFloat.optional

      attribute :security, Finary::Security
      attribute? :account, User::Account

      # Returns the user securities
      #
      # @return [Array<Finary::User::Security>] the user securities
      def self.all
        Finary.client.get_user_securities.map do |security_attributes|
          new(security_attributes)
        end
      end
    end
  end
end
