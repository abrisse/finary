module Finary
  module Views
    # Data classifies the assets into 3 categories
    class Data < Dry::Struct
      attribute :assets, Types::StatusHash
      attribute :liabilities, Types::StatusHash
    end
  end
end
