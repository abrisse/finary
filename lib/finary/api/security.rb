module Finary
  # Security
  class Security < Dry::Struct
    attribute :slug, Types::String
    attribute :name, Types::String.optional
    attribute :symbol, Types::String.optional
    attribute :logo_url, Types::String.optional
    attribute :security_type, Types::String
    attribute :current_price, Types::Float.optional
    attribute :subscription_fees_ratio, Types::Float.optional
    attribute :expense_ratio, Types::Float.optional
  end
end
