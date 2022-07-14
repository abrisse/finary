# frozen_string_literal: true

module Finary
  class RealEstate < Dry::Struct
    attribute :description, Types::String

    attribute :current_value, Types::Coercible::Integer
  end
end
