# frozen_string_literal: true

module Finary
  module User
    # FondsEuro
    class FondsEuro < Dry::Struct
      attribute :id, Types::Integer
      attribute :name, Types::String

      attribute :annual_yield, Types::Coercible::Float
      attribute :buying_price, Types::Coercible::Float.optional
      attribute :current_value, Types::Coercible::Float
      attribute :current_price, Types::Coercible::Float
      attribute :unrealized_pnl, Types::RoundedFloat.optional
      attribute :unrealized_pnl_percent, Types::RoundedFloat.optional
    end
  end
end
