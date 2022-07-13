# frozen_string_literal: true

module Finary
  class Bank < Dry::Struct
    attribute :id, Types::String
    attribute :slug, Types::String
    attribute :name, Types::String
    attribute :logo_url, Types::String.optional
    attribute :twitter_handle, Types::String.optional
    attribute :is_requestable, Types::Bool
    attribute :countries, Types::Strict::Array.of(Types::String)
  end
end
