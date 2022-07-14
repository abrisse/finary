# frozen_string_literal: true

module Finary
  module User
    module Views
      # Returns the user dashboard view
      #
      # @param [String] type the type ("gross", "net", "finary")
      # @param [String] type the period ("all", "1w", "1m", "ytd", "1y")
      #
      # @return [Finary::Views::Dashboard] the user dashboard view
      def self.dashboard(type: 'finary', period: '1w')
        attributes = Finary.client.get_user_view(:dashboard, type: type, period: period)

        Dashboard.new(attributes)
      end

      # Returns the user portfolio view
      #
      # @param [String] type the period ("all", "1w", "1m", "ytd", "1y")
      #
      # @return [Finary::Views::Portfolio] the user portfolio view
      def self.portfolio(period: '1w')
        attributes = Finary.client.get_user_view(:portfolio, period: period)

        Portfolio.new(attributes)
      end

      # Returns the user insights view
      #
      # @param [String] type the period ("all", "1w", "1m", "ytd", "1y")
      #
      # @return [Finary::Views::Portfolio] the user portfolio view
      def self.insights
        attributes = Finary.client.get_user_view(:insights)

        Insights.new(attributes)
      end
    end
  end
end

require_relative 'views/data'
require_relative 'views/dashboard'
require_relative 'views/portfolio'
