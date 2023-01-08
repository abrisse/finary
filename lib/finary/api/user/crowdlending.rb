# frozen_string_literal: true

module Finary
  module User
    # Crowdlending entry owned by the user
    class Crowdlending < Dry::Struct
      attribute :id, Types::String
      attribute :name, Types::String

      attribute :annual_yield, Types::Coercible::Float
      attribute :start_date, Types::Params::DateTime.optional
      attribute :month_duration, Types::Integer.optional

      attribute :initial_investment, Types::Coercible::Float
      attribute :current_value, Types::RoundedFloat.optional
      attribute :current_price, Types::RoundedFloat.optional
      attribute :unrealized_pnl, Types::RoundedFloat.optional
      attribute :unrealized_pnl_percent, Types::RoundedFloat.optional

      attribute? :account, User::Account

      # Returns all the crowdlendings
      #
      # @return [Array<Finary::User::Crowdlending>] the crowdlendings
      def self.all
        Finary.client.get_user_crowdlendings.map do |crowdlending_attributes|
          new(crowdlending_attributes)
        end
      end

      # Get a specific crowdlending
      #
      # @param [Integer] id the crowdlending ID
      #
      # @return [Finary::User::Crowdlending] the crowdlending
      def self.get(id)
        new(
          Finary.client.get_user_crowdlending(id)
        )
      end

      # Add a new crowdlending
      #
      # @param [Hash] attributes the crowdlending attributes
      #
      # @return [Finary::User::Crowdlending] the user crowdlending
      def self.create(attributes)
        new(
          Finary.client.add_user_crowdlending(attributes)
        )
      end

      # Update a crowdlending
      #
      # @param [Hash] attributes the crowdlending attributes
      #
      # @return [Finary::User::Crowdlending] the user crowdlending
      def update(attributes)
        new(
          Finary.client.update_user_crowdlending(id, attributes)
        )
      end

      # Delete a crowdlending
      #
      # @return [Bool] returns true if successful
      def delete
        Finary.client.delete_user_crowdlending(id)
      end
    end
  end
end
