# frozen_string_literal: true

module Finary
  module Types
    include Dry.Types

    StatusHash = Types::Hash.constructor do |hash|
      hash.transform_values do |v|
        Status.new(v)
      end
    end

    RoundedFloat = Types::Coercible::Float.constructor do |value|
      value.round(2)
    end
  end
end

module Finary
  # Declare main classes here to deal with circular references
  class Account < Dry::Struct; end
  class BankAccountType < Dry::Struct; end
  class Bank < Dry::Struct; end
  class CryptoEntry < Dry::Struct; end
  class Crypto < Dry::Struct; end
  class FondsEuro < Dry::Struct; end
  class GenericAsset < Dry::Struct; end
  class Investments < Dry::Struct; end
  class Loan < Dry::Struct; end
  class SecurityEntry < Dry::Struct; end
  class Security < Dry::Struct; end
  class Status < Dry::Struct; end
end

require_relative 'api/account'
require_relative 'api/bank'
require_relative 'api/bank_account_type'
require_relative 'api/crypto'
require_relative 'api/crypto_entry'
require_relative 'api/fonds_euro'
require_relative 'api/generic_asset'
require_relative 'api/investments'
require_relative 'api/loan'
require_relative 'api/security'
require_relative 'api/security_entry'
require_relative 'api/status'

require_relative 'api/views'
