require 'spec_helper'

describe Finary::User do
  subject(:user) do
    described_class.new('me')
  end

  before do
    allow(Finary).to receive(:client).and_return(finary_client)
  end

  let(:finary_client) do
    instance_double(Finary::Client)
  end

  describe '#id' do
    it 'returns the ID' do
      expect(user.id).to eq('me')
    end
  end

  describe '#get_user_generic_assets' do
    subject(:get_user_generic_assets) do
      user.get_user_generic_assets
    end

    let(:finary_client) do
      instance_double(Finary::Client, get_user_generic_assets: attributes)
    end

    let(:attributes) do
      [
        load_json('finary', 'etc', 'generic_asset.json')
      ]
    end

    it 'uses the HTTP client' do
      get_user_generic_assets

      expect(finary_client).to have_received(:get_user_generic_assets)
    end

    it 'returns the generic_assets' do
      expect(get_user_generic_assets).to match_array(
        [
          an_instance_of(Finary::GenericAsset)
        ]
      )
    end
  end
end