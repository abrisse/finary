# frozen_string_literal: true

module Finary
  # Status gives financial details on a given set of assets
  class Status < Dry::Struct
    attribute :amount, Types::Float.optional
    attribute :share, Types::Float.optional
    attribute :upnl, Types::Float.optional
    attribute :upnl_percent, Types::Float.optional
    attribute :evolution, Types::Float.optional
    attribute :evolution_percent, Types::Float.optional
    attribute? :period_evolution, Types::Float.optional
    attribute? :period_evolution_percent, Types::Float.optional
  end
end
