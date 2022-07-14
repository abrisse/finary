# frozen_string_literal: true

require 'spec_helper'

describe Finary::Crypto do
  subject(:crypto) do
    described_class.new(crypto_attributes)
  end

  let(:crypto_attributes) do
    load_json('crypto.json')
  end

  describe '#id' do
    it 'returns a string' do
      expect(crypto.id).to be_a(Integer)
    end
  end

  describe '#name' do
    it 'returns a string' do
      expect(crypto.name).to be_a(String)
    end
  end

  describe '#code' do
    it 'returns a string' do
      expect(crypto.code).to be_a(String)
    end
  end

  describe '#symbol' do
    it 'returns a string' do
      expect(crypto.symbol).to be_a(String)
    end
  end

  describe '#logo_url' do
    it 'returns a string' do
      expect(crypto.logo_url).to be_a(String)
    end
  end
end
