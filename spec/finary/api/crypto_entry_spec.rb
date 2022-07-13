# frozen_string_literal: true

require 'spec_helper'

describe Finary::CryptoEntry do
  subject(:crypto_entry) do
    described_class.new(crypto_entry_attributes)
  end

  let(:crypto_entry_attributes) do
    load_json('finary', 'etc', 'crypto_entry.json')
  end

  describe '#id' do
    it 'returns an integer' do
      expect(crypto_entry.id).to be_a(Integer)
    end
  end

  describe '#crypto' do
    it 'returns a crypto' do
      expect(crypto_entry.crypto).to be_a(Finary::Crypto)
    end
  end

  describe '#account' do
    it 'returns a account' do
      expect(crypto_entry.account).to be_a(Finary::Account)
    end
  end

  describe '#quantity' do
    it 'returns a float' do
      expect(crypto_entry.quantity).to be_a(Float)
    end
  end

  describe '#current_price' do
    it 'returns a float' do
      expect(crypto_entry.current_price).to be_a(Float)
    end
  end

  describe '#current_value' do
    it 'returns a float' do
      expect(crypto_entry.current_value).to be_a(Float)
    end
  end

  describe '#unrealized_pnl' do
    it 'returns a float' do
      expect(crypto_entry.unrealized_pnl).to be_a(Float)
    end
  end

  describe '#unrealized_pnl_percent' do
    it 'returns a float' do
      expect(crypto_entry.unrealized_pnl_percent).to be_a(Float)
    end
  end

  describe '#buying_price' do
    it 'returns a float' do
      expect(crypto_entry.buying_price).to be_a(Float)
    end
  end
end
