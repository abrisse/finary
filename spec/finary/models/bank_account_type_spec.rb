require 'spec_helper'

describe Finary::BankAccountType do
  let(:bank_attributes) do
    load_json('finary', 'etc', 'bank_account_type.json')
  end

  subject(:bank_account_type) do
    described_class.new(bank_attributes)
  end

  describe '#id' do
    it 'returns a string' do
      expect(bank_account_type.id).to be_a(String)
    end
  end

  describe '#slug' do
    it 'returns a string' do
      expect(bank_account_type.slug).to be_a(String)
    end
  end

  describe '#name' do
    it 'returns a string' do
      expect(bank_account_type.name).to be_a(String)
    end
  end

  describe '#display_name' do
    it 'returns a string' do
      expect(bank_account_type.display_name).to be_a(String)
    end
  end

  describe '#account_type' do
    it 'returns a string' do
      expect(bank_account_type.account_type).to be_a(String)
    end
  end

  describe '#subtype' do
    it 'returns a string' do
      expect(bank_account_type.subtype).to be_a(String)
    end
  end

  describe '#priority' do
    it 'returns an integer' do
      expect(bank_account_type.priority).to be_a(Integer)
    end
  end
end
