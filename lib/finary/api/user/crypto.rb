# frozen_string_literal: true

module Finary
  module User
    # Crypto entry owned by the user and linkedto a Crypto
    class Crypto < Dry::Struct
      attribute :id, Types::Integer
      attribute :owning_type, Types::String

      attribute :quantity, Types::Coercible::Float
      attribute :buying_price, Types::Coercible::Float.optional
      attribute :current_value, Types::Coercible::Float.optional
      attribute :current_price, Types::Coercible::Float.optional
      attribute :unrealized_pnl, Types::Coercible::Float.optional
      attribute :unrealized_pnl_percent, Types::Coercible::Float.optional

      attribute :crypto, Finary::Crypto
      attribute? :account, User::Account

      # Returns the user cryptos
      #
      # @return [Array<Finary::User::Crypto>] the user cryptos
      def self.all
        Finary.client.get_user_cryptos.map do |crypto_attributes|
          new(crypto_attributes)
        end
      end

      # Get a specific crypto
      #
      # @param [Integer] id the crypto ID
      #
      # @return [Finary::User::Crypto] the crypto
      def self.get(id)
        new(
          Finary.client.get_user_crypto(id)
        )
      end

      # Add a new crypto
      #
      # @param [Hash] attributes the asset attributes
      #
      # @return [Finary::User::Crypto] the user crypto
      def self.create(attributes)
        new(
          Finary.client.add_user_crypto(attributes)
        )
      end

      # Update a crypto
      #
      # @param [Hash] attributes the asset attributes
      #
      # @return [Finary::User::Crypto] the user crypto
      def update(attributes)
        new(
          Finary.client.update_user_crypto(id, attributes)
        )
      end

      # Delete a crypto
      #
      # @return [Bool] returns true if successful
      def delete
        Finary.client.delete_user_crypto(id)
      end
    end
  end
end
