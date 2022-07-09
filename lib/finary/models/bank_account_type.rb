module Finary
  class BankAccountType < Dry::Struct
    attribute :id, Types::String
    attribute :slug, Types::String
    attribute :name, Types::String
    attribute :account_type, Types::String
    attribute :subtype, Types::String
    attribute :display_name, Types::String
    attribute :priority, Types::Integer
  end
end
