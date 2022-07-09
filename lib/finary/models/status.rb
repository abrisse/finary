module Finary
  class Status < Dry::Struct
    attribute :amount, Types::Float.optional
    attribute :share, Types::Float.optional
    attribute :upnl, Types::Float.optional
    attribute :upnl_percent, Types::Float.optional
    attribute :evolution, Types::Float.optional
    attribute :evolution_percent, Types::Float.optional
    attribute :period_evolution, Types::Float.optional
    attribute :period_evolution_percent, Types::Float.optional
  end
end
