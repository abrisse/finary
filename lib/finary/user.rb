# frozen_string_literal: true

module Finary
  # Represents the User. This class allows to manipulate directly high level
  # Ruby classes, by relying on the finary http client wrapper that uses JSON.
  class User
    attr_reader :id

    # Returns the special user <me>
    #
    # @return [User] the user
    def self.me
      new('me')
    end

    # Instantiates a new user
    #
    # @param [String] id the user ID
    def initialize(id)
      @id = id
    end

    # Returns the user holdings accounts
    #
    # @return [Array<Finary::Account>] the user holdings accounts
    def get_holdings_accounts
      Finary.client.get_user_holdings_accounts.map do |account_attributes|
        Account.new(account_attributes)
      end
    end

    # Returns the user loans
    #
    # @return [Array<Finary::Loan>] the user loans
    def get_loans
      Finary.client.get_user_loans.map do |loan_attributes|
        Loan.new(loan_attributes)
      end
    end

    # Returns the user securities
    #
    # @return [Array<Finary::SecurityEntry>] the user securities
    def get_securities
      Finary.client.get_user_securities.map do |security_attributes|
        SecurityEntry.new(security_attributes)
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

    # Returns the user portfolio view
    #
    # @param [String] type the period ("all", "1w", "1m", "ytd", "1y")
    #
    # @return [Finary::Views::Portfolio] the user portfolio view
    def get_view_portfolio(period: '1w')
      attributes = Finary.client.get_user_view(:portfolio, period: period)

      Views::Portfolio.new(attributes)
    end

    # Returns the user insights view
    #
    # @param [String] type the period ("all", "1w", "1m", "ytd", "1y")
    #
    # @return [Finary::Views::Portfolio] the user portfolio view
    def get_view_insights
      attributes = Finary.client.get_user_view(:insights)

      Views::Insights.new(attributes)
    end
  end
end
