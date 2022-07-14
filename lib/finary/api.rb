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
  class BankAccountType < Dry::Struct; end
  class Bank < Dry::Struct; end
  class Crypto < Dry::Struct; end
  class Security < Dry::Struct; end
  class Status < Dry::Struct; end
end

require_relative 'api/bank'
require_relative 'api/bank_account_type'
require_relative 'api/crypto'
require_relative 'api/security'
require_relative 'api/status'
require_relative 'api/user'
