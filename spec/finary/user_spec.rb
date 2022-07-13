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

  describe '.me' do
    it 'returns the user <me>' do
      expect(Finary.me.id).to eq('me')
    end
  end

  describe '#id' do
    it 'returns the ID' do
      expect(user.id).to eq('me')
    end
  end

  describe '#get_cryptos' do
    subject(:get_cryptos) do
      user.get_cryptos
    end

    let(:finary_client) do
      instance_double(Finary::Client, get_user_cryptos: attributes)
    end

    let(:attributes) do
      [
        load_json('finary', 'etc', 'crypto_entry.json')
      ]
    end

    it 'uses the HTTP client' do
      get_cryptos

      expect(finary_client).to have_received(:get_user_cryptos)
    end

    it 'returns the security entries' do
      expect(get_cryptos).to match_array(
        [
          an_instance_of(Finary::CryptoEntry)
        ]
      )
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

    it 'returns the generic assets' do
      expect(get_generic_assets).to match_array(
        [
          an_instance_of(Finary::GenericAsset)
        ]
      )
    end
  end

  describe '#get_holdings_accounts' do
    subject(:get_holdings_accounts) do
      user.get_holdings_accounts
    end

    let(:finary_client) do
      instance_double(Finary::Client, get_user_holdings_accounts: attributes)
    end

    let(:attributes) do
      [
        load_json('finary', 'etc', 'account.json')
      ]
    end

    it 'uses the HTTP client' do
      get_holdings_accounts

      expect(finary_client).to have_received(:get_user_holdings_accounts)
    end

    it 'returns the accounts' do
      expect(get_holdings_accounts).to match_array(
        [
          an_instance_of(Finary::Account)
        ]
      )
    end
  end

  describe '#get_loans' do
    subject(:get_loans) do
      user.get_loans
    end

    let(:finary_client) do
      instance_double(Finary::Client, get_user_loans: attributes)
    end

    let(:attributes) do
      [
        load_json('finary', 'etc', 'loan.json')
      ]
    end

    it 'uses the HTTP client' do
      get_loans

      expect(finary_client).to have_received(:get_user_loans)
    end

    it 'returns the loans' do
      expect(get_loans).to match_array(
        [
          an_instance_of(Finary::Loan)
        ]
      )
    end
  end

  describe '#get_securities' do
    subject(:get_securities) do
      user.get_securities
    end

    let(:finary_client) do
      instance_double(Finary::Client, get_user_securities: attributes)
    end

    let(:attributes) do
      [
        load_json('finary', 'etc', 'security_entry.json')
      ]
    end

    it 'uses the HTTP client' do
      get_securities

      expect(finary_client).to have_received(:get_user_securities)
    end

    it 'returns the security entries' do
      expect(get_securities).to match_array(
        [
          an_instance_of(Finary::SecurityEntry)
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

  describe '#get_view_portfolio' do
    subject(:get_view_portfolio) do
      user.get_view_portfolio(period: 'ytd')
    end

    let(:finary_client) do
      instance_double(Finary::Client, get_user_view: attributes)
    end

    let(:attributes) do
      load_json('finary', 'etc', 'views', 'portfolio.json')
    end

    it 'uses the HTTP client' do
      get_view_portfolio

      expect(finary_client).to have_received(:get_user_view).with(:portfolio, period: 'ytd')
    end

    it 'returns the portfolio' do
      expect(get_view_portfolio).to be_a(Finary::Views::Portfolio)
    end
  end
end