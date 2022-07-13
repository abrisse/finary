# frozen_string_literal: true

require 'httparty'

module Finary
  class Client
    include HTTParty
    base_uri 'https://api.finary.com/'
    # debug_output $stdout

    DEVICE_ID = 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.0.0 Safari/537.36'

    # Instanciates a new Finary HTTP client
    #
    # @param [String] login the user login
    # @param [String] password the user password
    # @param [String] access_token a user access token
    def initialize(login: nil, password: nil, access_token: nil)
      @login = login
      @password = password
      @access_token = access_token
    end

    #######################################
    # Routes /users/me/generic_assets
    #######################################

    # Add a new user generic asset
    #
    # @param [Hash] attributes the generic asset attributes
    #
    # @return [Hash] the user generic asset
    def add_user_generic_asset(attributes)
      parse_response(
        self.class.post(
          '/users/me/generic_assets',
          headers: common_headers,
          body: attributes.to_json
        )
      )
    end

    # Update an existing user generic asset
    #
    # @param [Integer] id the generic asset id
    # @param [Hash] attributes the generic asset attributes
    #
    # @return [Hash] the user generic asset
    def update_user_generic_asset(id, attributes)
      parse_response(
        self.class.put(
          "/users/me/generic_assets/#{id}",
          headers: common_headers,
          body: attributes.to_json
        )
      )
    end

    # Delete an existing user generic asset
    #
    # @param [Integer] id the generic asset id
    #
    # @return [Bool] returns true if successful
    def delete_user_generic_asset(id)
      parse_response(
        self.class.delete(
          "/users/me/generic_assets/#{id}",
          headers: common_headers
        )
      )

      true
    end

    # Retrieves the user generic assets
    #
    # @return [Hash] the user generic assets
    def get_user_generic_assets
      parse_response(
        self.class.get(
          '/users/me/generic_assets',
          headers: common_headers
        )
      )
    end

    #######################################
    # Routes /users/me/holdings_accounts
    #######################################

    # Retrieves the user holdings accounts
    #
    # @return [Hash] the user holdings accounts
    def get_user_holdings_accounts
      parse_response(
        self.class.get(
          '/users/me/holdings_accounts',
          headers: common_headers
        )
      )
    end

    #######################################
    # Routes /users/me/securities
    #######################################

    # Retrieves the user securities
    #
    # @return [Hash] the user securities
    def get_user_securities
      parse_response(
        self.class.get(
          '/users/me/securities',
          headers: common_headers
        )
      )
    end

    #######################################
    # Routes /users/me/cryptos
    #######################################

    # Retrieves the user cryptos
    #
    # @return [Hash] the user cryptos
    def get_user_cryptos
      parse_response(
        self.class.get(
          '/users/me/cryptos',
          headers: common_headers
        )
      )
    end

    #######################################
    # Routes /users/me/loans
    #######################################

    # Retrieves the user loans
    #
    # @return [Hash] the user loans
    def get_user_loans
      parse_response(
        self.class.get(
          '/users/me/loans',
          headers: common_headers
        )
      )
    end

    #######################################
    # Routes /users/me/views
    #######################################

    # Get a specific user view
    #
    # @param [String] the view type
    # @param [Hash] the view parameters
    #
    # @return [Hash] the user view
    def get_user_view(type, params)
      parse_response(
        self.class.get(
          "/users/me/views/#{type}",
          query: params,
          headers: common_headers
        )
      )
    end

    protected

    attr_reader :login, :password, :access_token

    # @private
    #
    # @return [Logger] a usable logger
    def logger
      @logger ||= ::Logger.new($stdout)
    end

    def parse_response(response)
      if response.success?
        if (runtime = response.headers[:'x-runtime'])
          logger.debug "Request took #{(runtime.to_f * 1_000).to_i}ms"
        end

        JSON.parse(response.body, symbolize_names: true)[:result] if response.body
      else
        logger.debug "Request error #{response.code}"
        logger.debug response.body
        raise StandardError, "Request error #{response.code}"
      end
    end

    def common_headers
      {
        'accept' => 'application/json',
        'content-type' => 'application/json',
        'cookie' => auth_cookie_hash.to_cookie_string
      }
    end

    def auth_cookie_hash
      @auth_cookie_hash ||= build_auth_cookie_hash
    end

    def build_auth_cookie_hash
      HTTParty::CookieHash.new.tap do |cookie_hash|
        if access_token
          cookie_hash.add_cookies("finary_access_token=#{access_token}")
        elsif login && password
          signin.get_fields('Set-Cookie').each do |c|
            cookie_hash.add_cookies(c)
          end
        else
          raise StandardError,
            'To authenticate to Finary API, please provide either a access_token or a login/password.'
        end
      end
    end

    def signin
      self.class.post('/auth/signin',
        body: {
          email: login,
          password: password,
          device_id: DEVICE_ID
        }.to_json,
        headers: {
          'content-type': 'application/json',
          accept: 'application/json'
        })
    end
  end
end
