# frozen_string_literal: true

require 'spec_helper'

describe Finary::User::Views::Data do
  subject(:data) do
    described_class.new(data_attributes)
  end

  let(:data_attributes) do
    load_json('user', 'views', 'data.json')
  end

  describe '#assets' do
    it 'returns a hash of status' do
      expect(data.assets).to match(
        hash_including(
          checking_accounts: an_instance_of(Finary::Status),
          savings_accounts: an_instance_of(Finary::Status)
        )
      )
    end
  end

  describe '#liabilities' do
    it 'returns a hash of status' do
      expect(data.liabilities).to match(
        hash_including(
          credit_accounts: an_instance_of(Finary::Status),
          loans: an_instance_of(Finary::Status)
        )
      )
    end
  end
end
