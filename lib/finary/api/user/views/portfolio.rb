# frozen_string_literal: true

module Finary
  module User
    module Views
      # Portfolio gives a high view of the user assets
      class Portfolio < Dry::Struct
        attribute :last_user_sync_at, Types::Params::Date
        attribute :timeseries, Types::Array
        attribute :data, Data
      end
    end
  end
end
