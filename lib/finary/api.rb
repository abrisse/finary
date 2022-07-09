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

require_relative 'api/generic_asset'
require_relative 'api/security'
require_relative 'api/crypto'

require_relative 'api/security_entry'
require_relative 'api/crypto_entry'

require_relative 'api/bank_account_type'
require_relative 'api/bank'
require_relative 'api/account'
require_relative 'api/status'
require_relative 'api/dashboard'
require_relative 'api/investments'
