# frozen_string_literal: true

require 'nokogiri'

module Finary
  module Providers
    class ClubFunding < Base
      attr_reader :jwt_token

      PROVIDER_NAME = 'ClubFunding'

      # Instanciate a ClubFunding Provider
      #
      # @param [String] email the user email
      # @param [String] password the user password
      def initialize(email:, password:)
        @email = email
        @password = password
        super()
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
          name: clean_name(invest[:project_name]),
          initial_investment: clean_amount(invest[:amount_outstanding]),
          current_price: clean_amount(invest[:amount_outstanding])
        }
      end

      def clean_amount(amount)
        amount.tr('^[0-9,]', '').to_i
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
