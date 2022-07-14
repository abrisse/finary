# frozen_string_literal: true

require 'spec_helper'

describe Finary::User::FondsEuro do
  subject(:fonds_euro) do
    described_class.new(fonds_euro_attributes)
  end

  let(:fonds_euro_attributes) do
    load_json('user', 'fonds_euro.json')
  end

  describe '#id' do
    it 'returns an integer' do
      expect(fonds_euro.id).to be_a(Integer)
    end
  end

  describe '#annual_yield' do
    it 'returns a float' do
      expect(fonds_euro.annual_yield).to be_a(Float)
    end
  end

  describe '#buying_price' do
    it 'returns a float' do
      expect(fonds_euro.buying_price).to be_a(Float)
    end
  end

  describe '#current_price' do
    it 'returns a float' do
      expect(fonds_euro.current_price).to be_a(Float)
    end
  end

  describe '#current_value' do
    it 'returns a float' do
      expect(fonds_euro.current_value).to be_a(Float)
    end
  end

  describe '#unrealized_pnl' do
    it 'returns a float' do
      expect(fonds_euro.unrealized_pnl).to be_a(Float)
    end
  end

  describe '#unrealized_pnl_percent' do
    it 'returns a float' do
      expect(fonds_euro.unrealized_pnl_percent).to be_a(Float)
    end
  end
end
