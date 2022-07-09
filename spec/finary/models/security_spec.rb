require 'spec_helper'

describe Finary::Security do
  let(:security_attributes) do
    load_json('finary', 'etc', 'security.json')
  end

  subject(:security) do
    described_class.new(security_attributes)
  end

  describe '#slug' do
    it 'returns a string' do
      expect(security.slug).to be_a(String)
    end
  end

  describe '#name' do
    it 'returns a string' do
      expect(security.name).to be_a(String)
    end
  end

  describe '#symbol' do
    it 'returns a string' do
      expect(security.symbol).to be_a(String)
    end
  end

  describe '#logo_url' do
    it 'returns a string' do
      expect(security.logo_url).to be_a(String)
    end
  end

  describe '#security_type' do
    it 'returns a string' do
      expect(security.security_type).to be_a(String)
    end
  end

  describe '#current_price' do
    it 'returns a float' do
      expect(security.current_price).to be_a(Float)
    end
  end

  describe '#subscription_fees_ratio' do
    it 'returns a float' do
      expect(security.subscription_fees_ratio).to be_a(Float)
    end
  end

  describe '#expense_ratio' do
    it 'returns a float' do
      expect(security.expense_ratio).to be_a(Float)
    end
  end
end
