module Finary
  # Generic Assets are set manually by the User
  class GenericAsset < Dry::Struct
    attribute :id, Types::Integer
    attribute :name, Types::String
    attribute :updated_at, Types::Params::DateTime
    attribute :category, Types::String.optional

    attribute :quantity, Types::Coercible::Float
    attribute :buying_price, Types::Coercible::Float
    attribute :current_value, Types::Coercible::Float
    attribute :current_price, Types::Coercible::Float
    attribute :unrealized_pnl, Types::RoundedFloat.optional
    attribute :unrealized_pnl_percent, Types::RoundedFloat.optional
  end
end
