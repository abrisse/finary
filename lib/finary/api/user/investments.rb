# frozen_string_literal: true

module Finary
  module User
    # Investments returns the investment accounts
    class Investments < Dry::Struct
      attribute :total, Status
      attribute :accounts, Types::Strict::Array.of(User::Account)
    end
  end
end
