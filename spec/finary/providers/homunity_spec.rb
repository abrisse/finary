# frozen_string_literal: true

require 'spec_helper'

describe Finary::Providers::Homunity do
  subject(:homunity) do
    described_class.new('phpsessid')
  end

  let(:body_response) do
    File.read(fixture_path('providers', 'homunity.html'))
  end

  let(:response) do
    instance_double(HTTParty::Response, body: body_response)
  end

  let(:empty_response) do
    instance_double(HTTParty::Response, body: '<html></html>')
  end

  before do
    allow(HTTParty).to receive(:get).and_return(response, empty_response)
  end

  describe '#sync' do
    subject(:sync) do
      homunity.sync
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
      Finary::User::GenericAsset.new(generic_asset_attributes.merge(name: '[Homunity] Morel Lodge'))
    end

    let(:asset_to_delete) do
      Finary::User::GenericAsset.new(generic_asset_attributes.merge(name: '[Homunity] Opé Z'))
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
        .with(hash_including(name: '[Homunity] Les Pleiades'))
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
      homunity.investments
    end

    it 'returns the investments' do
      expect(investments).to match_array(
        [
          {
            name: '[Homunity] Morel Lodge',
            current_price: 1_000,
            quantity: 2,
            category: 'real_estate_crowdfunding',
            buying_price: 1_000
          },
          {
            name: '[Homunity] Les Pleiades',
            current_price: 1_000,
            quantity: 2,
            category: 'real_estate_crowdfunding',
            buying_price: 1_000
          }
        ]
      )
    end
  end
end
