require 'httparty'

module Finary
  class Client
    include HTTParty
    base_uri 'https://api.finary.com/'

    DEVICE_ID = 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.0.0 Safari/537.36'

    attr_reader :login, :password

    # Instanciates a new Finary HTTP client
    #
    # @param [String] login the user login
    # @param [String] password the user password
    def initialize(login:, password:)
      @login = login
      @password = password
    end

    # Retrieves the user generic assets
    def get_user_generic_assets
      parse_response(
        self.class.get(
          "/users/me/generic_assets",
          headers: auth_headers
        )
      )
    end

    # Retrieves the user holdings accounts
    def get_user_holdings_accounts
      parse_response(
        self.class.get(
          "/users/me/holdings_accounts",
          headers: auth_headers
        )
      )
    end

    def get_user_view(type, params)
      parse_response(
        self.class.get(
          "/users/me/views/#{type}",
          query: params,
          headers: auth_headers
        )
      )
    end

    protected

    def parse_response(response)
      if response.success?
        JSON.parse(response.body, symbolize_names: true)[:result]
      end
    end

    def auth_headers
      {
        accept: 'application/json',
        cookie: auth_cookie_hash.to_cookie_string
      }
    end

    def auth_cookie_hash
      @auth_cookie_hash ||= build_auth_cookie_hash
    end

    def build_auth_cookie_hash
      HTTParty::CookieHash.new.tap do |cookie_hash|
        signin.get_fields('Set-Cookie').each do |c|
          cookie_hash.add_cookies(c)
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
        }
      )
    end
  end
end
