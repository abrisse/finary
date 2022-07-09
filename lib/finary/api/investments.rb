module Finary
  # Investments returns the investment accounts
  class Investments < Dry::Struct
    attribute :total, Status
    attribute :accounts, Types::Strict::Array.of(Account)
  end
end
