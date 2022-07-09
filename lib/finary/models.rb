module Finary
  module Types
    include Dry.Types

    StatusHash = Types::Hash.constructor do |hash|
      hash.each_with_object({}) do |(k, v), h|
        h[k] = Status.new(v)
      end
    end

    RoundedFloat = Types::Coercible::Float.constructor do |value|
      value.round(2)
    end
  end
end

require_relative 'models/generic_asset'
require_relative 'models/security'
require_relative 'models/crypto'

require_relative 'models/security_entry'
require_relative 'models/crypto_entry'

require_relative 'models/bank_account_type'
require_relative 'models/bank'
require_relative 'models/account'
require_relative 'models/status'
require_relative 'models/dashboard'
require_relative 'models/investments'
