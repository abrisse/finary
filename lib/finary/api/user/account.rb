# frozen_string_literal: true

module Finary
  module User
    # Account
    class Account < Dry::Struct
      attribute :slug, Types::String
      attribute :id, Types::String
      attribute :name, Types::String
      attribute :manual_type, Types::String.optional
      attribute :last_sync_at, Types::Params::DateTime
      attribute :balance, Types::RoundedFloat.optional
      attribute :upnl, Types::RoundedFloat.optional
      attribute :upnl_percent, Types::RoundedFloat.optional
      attribute :unrealized_pnl, Types::RoundedFloat.optional
      attribute :unrealized_pnl_percent, Types::RoundedFloat.optional
      attribute :transactions_count, Types::Integer

      attribute :bank, Finary::Bank
      attribute? :securities, Types::Array.of(User::Security)
      attribute? :cryptos, Types::Array.of(User::Crypto)
      attribute? :fonds_euro, Types::Array.of(User::FondsEuro)

      # Returns the user holdings accounts
      #
      # @return [Array<Finary::Account>] the user holdings accounts
      def self.all
        Finary.client.get_user_holdings_accounts.map do |account_attributes|
          new(account_attributes)
        end
      end
    end
  end
end
