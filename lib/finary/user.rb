module Finary
  # Represents the User. This class allows to manipulate directly high level
  # Ruby classes, by relying on the finary http client wrapper that uses JSON.
  class User
    attr_reader :id

    # Instantiates a new user
    #
    # @param [String] id the user ID
    def initialize(id = 'me')
      @id = id
    end

    # Returns the user generic assets
    #
    # @return [Array<Finary::GenericAsset>] the user generic assets
    def get_user_generic_assets
      Finary.client.get_user_generic_assets.map do |attributes|
        GenericAsset.new(attributes)
      end
    end
  end
end
