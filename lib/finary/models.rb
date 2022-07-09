module Finary
  module Types
    include Dry.Types

    StatusHash = Types::Hash.constructor do |hash|
      hash.each_with_object({}) do |(k, v), h|
        h[k] = Status.new(v)
      end
    end
  end
end

require_relative 'models/status'
require_relative 'models/dashboard'
