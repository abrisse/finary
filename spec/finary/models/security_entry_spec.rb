require 'spec_helper'

describe Finary::SecurityEntry do
  let(:security_entry_attributes) do
    load_json('finary', 'etc', 'security_entry.json')
  end

  subject(:security_entry) do
    described_class.new(security_entry_attributes)
  end

  describe '#id' do
    it 'returns an integer' do
      expect(security_entry.id).to be_a(Integer)
    end
  end

  describe '#security' do
    it 'returns a security' do
      expect(security_entry.security).to be_a(Finary::Security)
    end
  end

  describe '#quantity' do
    it 'returns a float' do
      expect(security_entry.quantity).to be_a(Float)
    end
  end

  describe '#current_value' do
    it 'returns a float' do
      expect(security_entry.current_value).to be_a(Float)
    end
  end

  describe '#unrealized_pnl' do
    it 'returns a float' do
      expect(security_entry.unrealized_pnl).to be_a(Float)
    end
  end

  describe '#unrealized_pnl_percent' do
    it 'returns a float' do
      expect(security_entry.unrealized_pnl_percent).to be_a(Float)
    end
  end

  describe '#buying_price' do
    it 'returns a float' do
      expect(security_entry.buying_price).to be_a(Float)
    end
  end
end
