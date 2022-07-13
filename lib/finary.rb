require 'dry-struct'

module Finary
  # Configure finary credentials
  #
  # @yieldname [inary::Configuration] configuration the finary configuration
  def self.configure
    yield configuration
  end

  # @return [Finary::Configuration] the configuration
  def self.configuration
    @configuration ||= Configuration.new
  end

  # @return [Finary::Client] the finary client
  def self.client
    @client ||= Client.new(
      login: configuration.login,
      password: configuration.password,
      access_token: configuration.access_token
    )
  end

  # @return [Finary::User] the user <me>
  def self.me
    @user ||= User.me
  end
end

require_relative 'finary/configuration'
require_relative 'finary/api'

require_relative 'finary/client'
require_relative 'finary/user'
