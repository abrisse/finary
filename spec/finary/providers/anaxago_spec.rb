# frozen_string_literal: true

require 'spec_helper'

describe Finary::Providers::Anaxago do
  subject(:anaxago) do
    described_class.new(path)
  end

  let(:path) do
    fixture_path('providers', 'anaxago.csv')
  end

  describe '#sync' do
    subject(:sync) do
      anaxago.sync
    end

    before do
      allow(Finary::User::GenericAsset).to receive(:all).and_return(current_assets)
      allow(Finary::User::GenericAsset).to receive(:create).and_return(random_asset)

      allow(asset_to_update).to receive(:update)
      allow(asset_to_delete).to receive(:delete)
    end

    let(:current_assets) do
      [
        asset_to_update,
        asset_to_delete,
        asset_to_ignore
      ]
    end

    let(:random_asset) do
      Finary::User::GenericAsset.new(generic_asset_attributes)
    end

    let(:asset_to_update) do
      Finary::User::GenericAsset.new(generic_asset_attributes.merge(name: '[Anaxago] Opé B'))
    end

    let(:asset_to_delete) do
      Finary::User::GenericAsset.new(generic_asset_attributes.merge(name: '[Anaxago] Opé Z'))
    end

    let(:asset_to_ignore) do
      Finary::User::GenericAsset.new(generic_asset_attributes)
    end

    let(:generic_asset_attributes) do
      load_json('user', 'generic_asset.json')
    end

    it 'adds the new ongoing assets' do
      sync

      expect(Finary::User::GenericAsset)
        .to have_received(:create)
        .with(hash_including(name: '[Anaxago] Opé C'))
    end

    it 'adds the new waiting assets' do
      sync

      expect(Finary::User::GenericAsset)
        .to have_received(:create)
        .with(hash_including(name: '[Anaxago] Opé E'))
    end

    it 'updates the current assets' do
      sync

      expect(asset_to_update).to have_received(:update)
    end

    it 'removes the legacy assets' do
      sync

      expect(asset_to_delete).to have_received(:delete)
    end
  end

  describe '#ongoing_investments' do
    subject(:ongoing_investments) do
      anaxago.ongoing_investments
    end

    it 'returns the ongoing investments' do
      expect(ongoing_investments).to match_array(
        [
          {
            name: '[Anaxago] Opé B',
            current_price: 1.3199458809380638,
            quantity: 1663,
            category: 'real_estate_crowdfunding',
            buying_price: 1
          },
          {
            name: '[Anaxago] Opé C',
            current_price: 1.293457627118644,
            quantity: 1475,
            category: 'real_estate_crowdfunding',
            buying_price: 1
          }
        ]
      )
    end
  end

  describe '#waiting_investments' do
    subject(:waiting_investments) do
      anaxago.waiting_investments
    end

    it 'returns the waiting investments' do
      expect(waiting_investments).to match_array(
        [
          {
            name: '[Anaxago] Opé E',
            current_price: 1,
            quantity: 2000,
            category: 'real_estate_crowdfunding',
            buying_price: 1
          }
        ]
      )
    end
  end
end
