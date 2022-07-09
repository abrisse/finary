module Finary
  class Dashboard < Dry::Struct
    attribute :total, Finary::Status
    attribute :timeseries, Types::Array
    attribute :distribution, Types::StatusHash
  end
end
