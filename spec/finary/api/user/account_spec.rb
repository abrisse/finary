# frozen_string_literal: true

require 'spec_helper'

describe Finary::User::Account do
  subject(:account) do
    described_class.new(account_attributes)
  end

  let(:account_attributes) do
    load_json('user', 'account.json')
  end

  let(:finary_client) do
    instance_double(Finary::Client)
  end

  before do
    allow(Finary).to receive(:client).and_return(finary_client)
  end

  describe '#id' do
    it 'returns a string' do
      expect(account.id).to be_a(String)
    end
  end

  describe '#name' do
    it 'returns a string' do
      expect(account.name).to be_a(String)
    end
  end

  describe '#manual_type' do
    it 'returns a string' do
      expect(account.manual_type).to be_a(String)
    end
  end

  describe '#last_sync_at' do
    it 'returns a date' do
      expect(account.last_sync_at).to be_a(Date)
    end
  end

  describe '#balance' do
    it 'returns a float' do
      expect(account.balance).to be_a(Float)
    end
  end

  describe '#upnl' do
    it 'returns a float' do
      expect(account.upnl).to be_a(Float)
    end
  end

  describe '#upnl_percent' do
    it 'returns a float' do
      expect(account.upnl_percent).to be_a(Float)
    end
  end

  describe '#unrealized_pnl' do
    it 'returns a float' do
      expect(account.unrealized_pnl).to be_a(Float)
    end
  end

  describe '#unrealized_pnl_percent' do
    it 'returns a float' do
      expect(account.unrealized_pnl_percent).to be_a(Float)
    end
  end

  describe '#bank' do
    it 'returns a bank' do
      expect(account.bank).to be_a(Finary::Bank)
    end
  end

  describe '#securities' do
    it 'returns the securities entries' do
      expect(account.securities).to match_array(
        [
          an_instance_of(Finary::User::Security)
        ]
      )
    end
  end

  describe '#cryptos' do
    it 'returns the cryptos entries' do
      expect(account.cryptos).to match_array(
        [
          an_instance_of(Finary::User::Crypto)
        ]
      )
    end
  end

  describe '#fonds_euro' do
    it 'returns the fonds euro' do
      expect(account.fonds_euro).to match_array(
        [
          an_instance_of(Finary::User::FondsEuro)
        ]
      )
    end
  end

  describe '.all' do
    subject(:get_holdings_accounts) do
      described_class.all
    end

    let(:finary_client) do
      instance_double(Finary::Client, get_user_holdings_accounts: [account_attributes])
    end

    it 'uses the HTTP client' do
      get_holdings_accounts

      expect(finary_client).to have_received(:get_user_holdings_accounts)
    end

    it 'returns the accounts' do
      expect(get_holdings_accounts).to match_array(
        [
          an_instance_of(described_class)
        ]
      )
    end
  end

  describe '.create' do
    subject(:create_holding_account) do
      described_class.create(params)
    end

    let(:params) do
      {
        name: 'my account',
        manual_type: 'crowdlending',
        bank_account_type: {
          name: 'crowdlending'
        },
        currency: { code: 'EUR' }
      }
    end

    let(:finary_client) do
      instance_double(Finary::Client, add_user_holding_account: account_attributes)
    end

    it 'uses the HTTP client' do
      create_holding_account

      expect(finary_client).to have_received(:add_user_holding_account).with(params)
    end

    it 'returns the account' do
      expect(create_holding_account).to be_an_instance_of(described_class)
    end
  end

  describe '.find' do
    subject(:find_holding_account) do
      described_class.find('Assurance vie Linxea', manual_type: 'stocks')
    end

    let(:finary_client) do
      instance_double(Finary::Client, get_user_holdings_accounts: [account_attributes])
    end

    it 'uses the HTTP client' do
      find_holding_account

      expect(finary_client).to have_received(:get_user_holdings_accounts)
    end

    context 'when an account is found' do
      it 'returns the account' do
        expect(find_holding_account).to have_attributes(
          class: described_class,
          name: 'Assurance vie Linxea'
        )
      end
    end

    context 'when no account is found' do
      subject(:find_holding_account) do
        described_class.find('Unknow', manual_type: 'stocks')
      end

      it 'returns the account' do
        expect { find_holding_account }.to raise_error(StandardError, 'Account Unknow not found')
      end
    end
  end
end
