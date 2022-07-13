# frozen_string_literal: true

module Finary
  # Crypto
  class Crypto < Dry::Struct
    attribute :id, Types::Integer
    attribute :name, Types::String.optional
    attribute :code, Types::String.optional
    attribute :symbol, Types::String.optional

    attribute :logo_url, Types::String.optional
  end
end
