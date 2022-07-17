# frozen_string_literal: true

require 'spec_helper'

describe Finary::Providers::ClubFunding do
  subject(:club_funding) do
    described_class.new(email: 'john.doe@gmail.com', password: '12345')
  end

  let(:get_ongoing_investments) do
    load_json('providers', 'club_funding.json')
  end

  let(:club_funding_client) do
    instance_double(
      Finary::Providers::ClubFunding::Client, get_ongoing_investments: get_ongoing_investments
    )
  end

  before do
    allow(club_funding).to receive(:client).and_return(club_funding_client)
  end

  describe '#sync' do
    subject(:sync) do
      club_funding.sync
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
      Finary::User::GenericAsset.new(generic_asset_attributes.merge(name: '[ClubFunding] Opé A'))
    end

    let(:asset_to_delete) do
      Finary::User::GenericAsset.new(generic_asset_attributes.merge(name: '[ClubFunding] Opé Z'))
    end

    let(:asset_to_ignore) do
      Finary::User::GenericAsset.new(generic_asset_attributes)
    end

    let(:generic_asset_attributes) do
      load_json('user', 'generic_asset.json')
    end

    it 'adds the new assets' do
      sync

      expect(Finary::User::GenericAsset)
        .to have_received(:create)
        .with(hash_including(name: '[ClubFunding] Opé B'))
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

  describe '#investments' do
    subject(:investments) do
      club_funding.investments
    end

    it 'returns the investments' do
      expect(investments).to match_array(
        [
          {
            name: '[ClubFunding] Opé A',
            current_price: 1_000,
            quantity: 2,
            category: 'real_estate_crowdfunding',
            buying_price: 1_000
          },
          {
            name: '[ClubFunding] Opé B',
            current_price: 1_000,
            quantity: 1,
            category: 'real_estate_crowdfunding',
            buying_price: 1_000
          }
        ]
      )
    end
  end
end
