require 'spec_helper'

describe Finary::GenericAsset do
  let(:generic_asset_attributes) do
    load_json('finary', 'etc', 'generic_asset.json')
  end

  subject(:generic_asset) do
    described_class.new(generic_asset_attributes)
  end

  describe '#id' do
    it 'returns an integer' do
      expect(generic_asset.id).to be_a(Integer)
    end
  end

  describe '#name' do
    it 'returns a string' do
      expect(generic_asset.name).to be_a(String)
    end
  end

  describe '#category' do
    it 'returns a string' do
      expect(generic_asset.category).to be_a(String)
    end
  end

  describe '#updated_at' do
    it 'returns a Date' do
      expect(generic_asset.updated_at).to be_a(Date)
    end
  end

  describe '#quantity' do
    it 'returns a float' do
      expect(generic_asset.quantity).to be_a(Float)
    end
  end

  describe '#buying_price' do
    it 'returns a float' do
      expect(generic_asset.buying_price).to be_a(Float)
    end
  end

  describe '#current_price' do
    it 'returns a float' do
      expect(generic_asset.current_price).to be_a(Float)
    end
  end

  describe '#current_value' do
    it 'returns a float' do
      expect(generic_asset.current_value).to be_a(Float)
    end
  end

  describe '#unrealized_pnl' do
    it 'returns a float' do
      expect(generic_asset.unrealized_pnl).to be_a(Float)
    end
  end

  describe '#unrealized_pnl_percent' do
    it 'returns a float' do
      expect(generic_asset.unrealized_pnl_percent).to be_a(Float)
    end
  end
end
