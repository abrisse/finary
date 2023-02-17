# frozen_string_literal: true

module Finary
  module User
    # Account
    class Account < Dry::Struct
      attribute :slug, Types::String
      attribute :id, Types::String
      attribute :name, Types::String
      attribute :manual_type, Types::String.optional
      attribute :last_sync_at, Types::Params::DateTime.optional
      attribute :balance, Types::RoundedFloat.optional
      attribute :upnl, Types::RoundedFloat.optional
      attribute :upnl_percent, Types::RoundedFloat.optional
      attribute :unrealized_pnl, Types::RoundedFloat.optional
      attribute :unrealized_pnl_percent, Types::RoundedFloat.optional
      attribute :transactions_count, Types::Integer

      attribute :bank, Finary::Bank
      attribute? :securities, Types::Array.of(User::Security)
      attribute? :cryptos, Types::Array.of(User::Crypto)
      attribute? :crowdlendings, Types::Array.of(User::Crowdlending)
      attribute? :fonds_euro, Types::Array.of(User::FondsEuro)

      # Returns the user holdings accounts
      #
      # @return [Array<Finary::Account>] the user holdings accounts
      def self.all
        Finary.client.get_user_holdings_accounts.map do |account_attributes|
          new(account_attributes)
        end
      end

      # Get a specific account
      #
      # @param [Integer] id account ID
      #
      # @return [Finary::User::Account] the account
      def self.get(id)
        new(
          Finary.client.get_user_holding_account(id)
        )
      end

      # Add a new account
      #
      # @param [Hash] attributes the account attributes
      #
      # @return [Finary::User::Account] the user account
      def self.create(attributes)
        new(
          Finary.client.add_user_holding_account(attributes)
        )
      end

      # Find a specific account
      #
      # @param [String] name the account name
      # @param [String] manual_type the account type
      #
      # @return [Finary::User::Account] the account
      def self.find(name, manual_type: nil)
        Finary::User::Account.all.detect do |a|
          (manual_type.nil? || a.manual_type == manual_type) && a.name.casecmp(name).zero?
        end or raise StandardError, "Account #{name} not found"
      end
    end
  end
end
