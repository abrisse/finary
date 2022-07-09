module Finary
  module Views
  # Dashboard gives a high view of the user assets
    class Dashboard < Dry::Struct
      attribute :total, Status
      attribute :timeseries, Types::Array
      attribute :distribution, Types::StatusHash
    end
  end
end
