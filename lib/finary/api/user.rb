# frozen_string_literal: true

module Finary
  module User
    # Declare main classes here to deal with circular references
    class Account < Dry::Struct; end
    class Crowdlending < Dry::Struct; end
    class Crypto < Dry::Struct; end
    class FondsEuro < Dry::Struct; end
    class GenericAsset < Dry::Struct; end
    class Investments < Dry::Struct; end
    class Loan < Dry::Struct; end
    class Security < Dry::Struct; end
  end
end

require_relative 'user/account'
require_relative 'user/crowdlending'
require_relative 'user/crypto'
require_relative 'user/fonds_euro'
require_relative 'user/generic_asset'
require_relative 'user/investments'
require_relative 'user/loan'
require_relative 'user/security'
require_relative 'user/views'
