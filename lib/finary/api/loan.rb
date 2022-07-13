module Finary
  # Loan
  class Loan < Dry::Struct
    attribute :id, Types::Integer
    attribute :name, Types::String

    attribute :loan_type, Types::String
    attribute :loan_category, Types::String
    attribute :month_duration, Types::Coercible::Integer
    attribute :start_date, Types::Params::Date
    attribute :end_date, Types::Params::Date
    attribute :ownership_percentage, Types::Coercible::Float
    attribute :loan_to_value, Types::RoundedFloat.optional
    attribute :total_amount, Types::Coercible::Integer
    attribute :monthly_repayment, Types::Coercible::Float
    attribute :insurance_rate, Types::Coercible::Float.optional
    attribute :fixed_costs, Types::Coercible::Float.optional
    attribute :elapsed_months, Types::Integer
    attribute :remaining_months, Types::Integer
    attribute :outstanding_capital, Types::Coercible::Integer
    attribute :outstanding_amount, Types::Coercible::Integer
    attribute :contribution, Types::Coercible::Float.optional
  end
end
