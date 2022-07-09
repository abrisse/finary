module Finary
  # Investments returns the investment accounts
  class Investments < Dry::Struct
    attribute :total, Finary::Status
    attribute :accounts, Types::Strict::Array.of(Account)
  end
end
