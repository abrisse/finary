module Finary
  # Account
  class Account < Dry::Struct
    attribute :slug, Types::String
    attribute :id, Types::String
    attribute :name, Types::String
    attribute :manual_type, Types::String.optional
    attribute :last_sync_at, Types::Params::DateTime
    attribute :balance, Types::RoundedFloat.optional
    attribute :upnl, Types::RoundedFloat.optional
    attribute :display_upnl, Types::RoundedFloat.optional
    attribute :upnl_percent, Types::RoundedFloat.optional
    attribute :unrealized_pnl, Types::RoundedFloat.optional
    attribute :display_unrealized_pnl, Types::RoundedFloat.optional
    attribute :unrealized_pnl_percent, Types::RoundedFloat.optional
    attribute :transactions_count, Types::Integer
  end
end
