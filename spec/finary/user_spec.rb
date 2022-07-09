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

  describe '#get_generic_assets' do
    subject(:get_generic_assets) do
      user.get_generic_assets
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
      get_generic_assets

      expect(finary_client).to have_received(:get_user_generic_assets)
    end

    it 'returns the generic_assets' do
      expect(get_generic_assets).to match_array(
        [
          an_instance_of(Finary::GenericAsset)
        ]
      )
    end
  end

  describe '#get_view_dashboard' do
    subject(:get_view_dashboard) do
      user.get_view_dashboard(type: 'gross', period: 'ytd')
    end

    let(:finary_client) do
      instance_double(Finary::Client, get_user_view: attributes)
    end

    let(:attributes) do
      load_json('finary', 'etc', 'views', 'dashboard.json')
    end

    it 'uses the HTTP client' do
      get_view_dashboard

      expect(finary_client).to have_received(:get_user_view).with(:dashboard, type: 'gross', period: 'ytd')
    end

    it 'returns the dashboard' do
      expect(get_view_dashboard).to be_a(Finary::Views::Dashboard)
    end
  end
end