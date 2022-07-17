# frozen_string_literal: true

require 'nokogiri'

module Finary
  module Providers
    class ClubFunding
      attr_reader :jwt_token

      # Instanciate a ClubFunding Provider
      #
      # @param [String] email the user email
      # @param [String] password the user password
      def initialize(email:, password:)
        @email = email
        @password = password
      end

      # Run the synchronization
      def sync
        current_club_funding_assets = build_current_club_funding_assets

        investments.each do |asset_attributes|
          if (asset = current_club_funding_assets.delete(asset_attributes[:name]))
            Finary.logger.debug "Update generic asset #{asset_attributes[:name]}"
            asset.update(asset_attributes)
          else
            Finary.logger.debug "Add generic asset #{asset_attributes[:name]}"
            Finary::User::GenericAsset.create(asset_attributes)
          end
        end

        current_club_funding_assets.each_value do |asset|
          Finary.logger.debug "Remove generic asset #{asset.name}"
          asset.delete
        end
      end

      # Retrieve and return the ClubFunding investments
      #
      # @return [Array<Hash>] the ClubFunding investments
      def investments
        @investments ||= build_investments
      end

      private

      attr_reader :email, :password

      def client
        @client ||= build_client
      end

      def build_client
        Client.new(email: email, password: password)
      end

      def build_investments
        client.get_ongoing_investments[:ongoing_list].map do |invest|
          build_investment(invest)
        end
      end

      def build_investment(invest)
        {
          name: "[ClubFunding] #{clean_name(invest[:project_name])}",
          category: 'real_estate_crowdfunding',
          buying_price: 1_000,
          quantity: clean_amount(invest[:amount_outstanding]) / 1_000,
          current_price: 1_000
        }
      end

      def clean_amount(amount)
        amount.tr('^[0-9,]', '').to_i
      end

      def clean_name(name)
        name.tr('&', '-')
      end

      def build_current_club_funding_assets
        club_funding_assets = Finary::User::GenericAsset.all.keep_if do |a|
          a.name.start_with?('[ClubFunding]')
        end

        club_funding_assets.each_with_object({}) do |a, h|
          h[a.name] = a
        end
      end

      class Client
        include HTTParty
        base_uri 'https://api.clubfunding.fr/api/'
        # debug_output $stdout

        # Instanciates a new ClubFunding HTTP client
        #
        # @param [String] email the user email
        # @param [String] password the user password
        def initialize(email: nil, password: nil)
          @email = email
          @password = password
        end

        # Retrieves the user ongoing investments
        #
        # @return [Hash] the ongoing investments
        def get_ongoing_investments
          parse_response(
            self.class.post('/dashboard-ongoing-list',
              headers: common_headers)
          )
        end

        private

        attr_reader :email, :password

        def common_headers
          {
            'accept' => 'application/json',
            'authorization' => "Bearer #{jwt_token}"
          }
        end

        def jwt_token
          @jwt_token ||= build_jwt_token
        end

        def build_jwt_token
          result = signin
          raise StandardError, "[ClubFunding] #{result[:errmsg]}" if result[:errmsg] && !result[:errmsg].empty?

          result[:response][:token]
        end

        def signin
          parse_response(
            self.class.post('/login',
              body: {
                email: email,
                password: password
              }.to_json,
              headers: {
                'content-type': 'application/json',
                accept: 'application/json'
              })
          )
        end

        def parse_response(response)
          if response.success?
            JSON.parse(response.body, symbolize_names: true) if response.body
          else
            Finary.logger.debug "[ClubFunding] Request error #{response.code}"
            Finary.logger.debug response.body
            raise StandardError, "[ClubFunding] Request error #{response.code}"
          end
        end
      end
    end
  end
end
