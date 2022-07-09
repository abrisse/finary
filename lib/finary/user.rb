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
    def get_generic_assets
      Finary.client.get_user_generic_assets.map do |attributes|
        GenericAsset.new(attributes)
      end
    end

    # Returns the user dashboard view
    #
    # @param [String] type the type ("gross", "net", "finary")
    # @param [String] type the period ("all", "1w", "1m", "ytd", "1y")
    #
    # @return [Finary::Views::Dashboard] the user dashboard view
    def get_view_dashboard(type: 'finary', period: '1w')
      attributes = Finary.client.get_user_view(:dashboard, type: type, period: period)

      Views::Dashboard.new(attributes)
    end
  end
end
