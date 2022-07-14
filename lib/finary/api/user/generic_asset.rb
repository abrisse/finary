# frozen_string_literal: true

module Finary
  module User
    # Generic Assets are set manually by the User
    class GenericAsset < Dry::Struct
      attribute :id, Types::Integer
      attribute :name, Types::String
      attribute :updated_at, Types::Params::DateTime
      attribute :category, Types::String.optional

      attribute :quantity, Types::Coercible::Float
      attribute :buying_price, Types::Coercible::Float
      attribute :current_value, Types::Coercible::Float
      attribute :current_price, Types::Coercible::Float
      attribute :unrealized_pnl, Types::RoundedFloat.optional
      attribute :unrealized_pnl_percent, Types::RoundedFloat.optional

      # Returns all the generic assets
      #
      # @return [Array<Finary::User::GenericAsset>] the generic assets
      def self.all
        Finary.client.get_user_generic_assets.map do |generic_asset_attributes|
          new(generic_asset_attributes)
        end
      end

      # Get a specific generic asset
      #
      # @param [Integer] id the generic asset ID
      #
      # @return [Finary::User::GenericAsset] the generic asset
      def self.get(id)
        new(
          Finary.client.get_user_generic_asset(id)
        )
      end

      # Add a new generic asset
      #
      # @param [Hash] attributes the asset attributes
      #
      # @return [Finary::User::GenericAsset] the user generic asset
      def self.create(attributes)
        new(
          Finary.client.add_user_generic_asset(attributes)
        )
      end

      # Update a generic asset
      #
      # @param [Hash] attributes the asset attributes
      #
      # @return [Finary::User::GenericAsset] the user generic asset
      def update(attributes)
        new(
          Finary.client.update_user_generic_asset(id, attributes)
        )
      end

      # Delete a generic asset
      #
      # @return [Bool] returns true if successful
      def delete
        Finary.client.delete_user_generic_asset(id)
      end
    end
  end
end
