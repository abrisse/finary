# frozen_string_literal: true

require 'spec_helper'

describe Finary::User::Crypto do
  subject(:crypto) do
    described_class.new(crypto_attributes)
  end

  let(:crypto_attributes) do
    load_json('user', 'crypto.json')
  end

  let(:finary_client) do
    instance_double(Finary::Client)
  end

  before do
    allow(Finary).to receive(:client).and_return(finary_client)
  end

  describe '#id' do
    it 'returns an integer' do
      expect(crypto.id).to be_a(Integer)
    end
  end

  describe '#crypto' do
    it 'returns a crypto' do
      expect(crypto.crypto).to be_a(Finary::Crypto)
    end
  end

  describe '#account' do
    it 'returns a account' do
      expect(crypto.account).to be_a(Finary::User::Account)
    end
  end

  describe '#quantity' do
    it 'returns a float' do
      expect(crypto.quantity).to be_a(Float)
    end
  end

  describe '#current_price' do
    it 'returns a float' do
      expect(crypto.current_price).to be_a(Float)
    end
  end

  describe '#current_value' do
    it 'returns a float' do
      expect(crypto.current_value).to be_a(Float)
    end
  end

  describe '#unrealized_pnl' do
    it 'returns a float' do
      expect(crypto.unrealized_pnl).to be_a(Float)
    end
  end

  describe '#unrealized_pnl_percent' do
    it 'returns a float' do
      expect(crypto.unrealized_pnl_percent).to be_a(Float)
    end
  end

  describe '#buying_price' do
    it 'returns a float' do
      expect(crypto.buying_price).to be_a(Float)
    end
  end

  describe '.all' do
    subject(:get_cryptos) do
      described_class.all
    end

    let(:finary_client) do
      instance_double(Finary::Client, get_user_cryptos: [crypto_attributes])
    end

    it 'uses the HTTP client' do
      get_cryptos

      expect(finary_client).to have_received(:get_user_cryptos)
    end

    it 'returns the security entries' do
      expect(get_cryptos).to match_array(
        [
          an_instance_of(described_class)
        ]
      )
    end
  end

  describe '.get' do
    subject(:get_crypto) do
      described_class.get(42)
    end

    let(:finary_client) do
      instance_double(Finary::Client, get_user_crypto: crypto_attributes)
    end

    it 'uses the HTTP client' do
      get_crypto

      expect(finary_client).to have_received(:get_user_crypto).with(42)
    end

    it 'returns the crypto' do
      expect(get_crypto).to be_an_instance_of(described_class)
    end
  end

  describe '.create' do
    subject(:create_crypto) do
      described_class.create(params)
    end

    let(:params) do
      {
        buying_price: 4,
        quantity: 42
      }
    end

    let(:finary_client) do
      instance_double(Finary::Client, add_user_crypto: crypto_attributes)
    end

    it 'uses the HTTP client' do
      create_crypto

      expect(finary_client).to have_received(:add_user_crypto).with(params)
    end

    it 'returns the crypto' do
      expect(create_crypto).to be_an_instance_of(described_class)
    end
  end

  describe '#update' do
    subject(:update_crypto) do
      crypto.update(params)
    end

    let(:params) do
      {
        buying_price: 4,
        quantity: 42
      }
    end

    let(:finary_client) do
      instance_double(Finary::Client, update_user_crypto: crypto_attributes)
    end

    it 'uses the HTTP client' do
      update_crypto

      expect(finary_client)
        .to have_received(:update_user_crypto)
        .with(22_705_781, params)
    end

    it 'returns the crypto' do
      expect(update_crypto).to be_an_instance_of(described_class)
    end
  end

  describe '#delete' do
    subject(:delete_crypto) do
      crypto.delete
    end

    let(:finary_client) do
      instance_double(Finary::Client, delete_user_crypto: true)
    end

    it 'uses the HTTP client' do
      delete_crypto

      expect(finary_client)
        .to have_received(:delete_user_crypto)
        .with(22_705_781)
    end

    it 'returns the crypto' do
      expect(delete_crypto).to be_truthy
    end
  end
end
