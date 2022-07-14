# frozen_string_literal: true

module Finary
  # Crypto entry owned by the user and linkedto a Crypto
  class CryptoEntry < Dry::Struct
    attribute :id, Types::Integer
    attribute :owning_type, Types::String

    attribute :quantity, Types::Coercible::Float
    attribute :buying_price, Types::Coercible::Float.optional
    attribute :current_value, Types::Coercible::Float.optional
    attribute :current_price, Types::Coercible::Float.optional
    attribute :unrealized_pnl, Types::Coercible::Float.optional
    attribute :unrealized_pnl_percent, Types::Coercible::Float.optional

    attribute :crypto, Crypto
    attribute? :account, Account

    # Returns the user cryptos
    #
    # @return [Array<Finary::CryptoEntry>] the user cryptos
    def self.all
      Finary.client.get_user_cryptos.map do |crypto_attributes|
        new(crypto_attributes)
      end
    end
  end
end
