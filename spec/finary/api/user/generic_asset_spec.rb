# frozen_string_literal: true

require 'spec_helper'

describe Finary::User::GenericAsset do
  subject(:generic_asset) do
    described_class.new(generic_asset_attributes)
  end

  before do
    allow(Finary).to receive(:client).and_return(finary_client)
  end

  let(:finary_client) do
    instance_double(Finary::Client)
  end

  let(:generic_asset_attributes) do
    load_json('user', 'generic_asset.json')
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

  describe '.all' do
    subject(:all_generic_assets) do
      described_class.all
    end

    let(:finary_client) do
      instance_double(Finary::Client, get_user_generic_assets: [generic_asset_attributes])
    end

    it 'uses the HTTP client' do
      all_generic_assets

      expect(finary_client).to have_received(:get_user_generic_assets)
    end

    it 'returns the generic assets' do
      expect(all_generic_assets).to match_array(
        [
          an_instance_of(described_class)
        ]
      )
    end
  end

  describe '.get' do
    subject(:get_generic_asset) do
      described_class.get(42)
    end

    let(:finary_client) do
      instance_double(Finary::Client, get_user_generic_asset: generic_asset_attributes)
    end

    it 'uses the HTTP client' do
      get_generic_asset

      expect(finary_client).to have_received(:get_user_generic_asset).with(42)
    end

    it 'returns the generic asset' do
      expect(get_generic_asset).to be_an_instance_of(described_class)
    end
  end

  describe '.create' do
    subject(:create_generic_asset) do
      described_class.create(params)
    end

    let(:params) do
      {
        buying_price: 4,
        category: 'real_estate_crowdfunding',
        current_price: 4,
        name: 'asset',
        quantity: 42
      }
    end

    let(:finary_client) do
      instance_double(Finary::Client, add_user_generic_asset: generic_asset_attributes)
    end

    it 'uses the HTTP client' do
      create_generic_asset

      expect(finary_client).to have_received(:add_user_generic_asset).with(params)
    end

    it 'returns the generic asset' do
      expect(create_generic_asset).to be_an_instance_of(described_class)
    end
  end

  describe '#update' do
    subject(:update_generic_asset) do
      generic_asset.update(params)
    end

    let(:params) do
      {
        buying_price: 4,
        category: 'real_estate_crowdfunding',
        current_price: 4,
        name: 'asset',
        quantity: 42
      }
    end

    let(:finary_client) do
      instance_double(Finary::Client, update_user_generic_asset: generic_asset_attributes)
    end

    it 'uses the HTTP client' do
      update_generic_asset

      expect(finary_client)
        .to have_received(:update_user_generic_asset)
        .with(23_206, params)
    end

    it 'returns the generic asset' do
      expect(update_generic_asset).to be_an_instance_of(described_class)
    end
  end

  describe '#delete' do
    subject(:delete_generic_asset) do
      generic_asset.delete
    end

    let(:finary_client) do
      instance_double(Finary::Client, delete_user_generic_asset: true)
    end

    it 'uses the HTTP client' do
      delete_generic_asset

      expect(finary_client)
        .to have_received(:delete_user_generic_asset)
        .with(23_206)
    end

    it 'returns the generic asset' do
      expect(delete_generic_asset).to be_truthy
    end
  end
end
