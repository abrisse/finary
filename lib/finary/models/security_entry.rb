module Finary
  # Security entry contained in a Account and linked
  # to a Security
  class SecurityEntry < Dry::Struct
    attribute :id, Types::Integer

    attribute :quantity, Types::Float.optional
    attribute :current_value, Types::Float.optional
    attribute :display_current_value, Types::Float.optional
    attribute :unrealized_pnl, Types::RoundedFloat.optional
    attribute :display_unrealized_pnl, Types::RoundedFloat.optional
    attribute :unrealized_pnl_percent, Types::RoundedFloat.optional
    attribute :buying_price, Types::RoundedFloat.optional
    attribute :display_buying_price, Types::RoundedFloat.optional

    attribute :security, Security
  end
end
