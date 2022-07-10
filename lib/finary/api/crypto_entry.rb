module Finary
  # Crypto entry owned by the user and linkedto a Crypto
  class CryptoEntry < Dry::Struct
    attribute :id, Types::Integer
    attribute :owning_type, Types::String

    attribute :quantity, Types::Coercible::Float
    attribute :buying_price, Types::Coercible::Float
    attribute :current_value, Types::Coercible::Float
    attribute :current_price, Types::Coercible::Float
    attribute :unrealized_pnl, Types::Coercible::Float
    attribute :unrealized_pnl_percent, Types::Coercible::Float

    attribute :crypto, Crypto
    attribute? :account, Account
  end
end
