# frozen_string_literal: true

require 'spec_helper'

describe Finary::User::Security do
  subject(:security) do
    described_class.new(security_attributes)
  end

  let(:security_attributes) do
    load_json('user', 'security.json')
  end

  let(:finary_client) do
    instance_double(Finary::Client)
  end

  before do
    allow(Finary).to receive(:client).and_return(finary_client)
  end

  describe '#id' do
    it 'returns an integer' do
      expect(security.id).to be_a(Integer)
    end
  end

  describe '#security' do
    it 'returns a security' do
      expect(security.security).to be_a(Finary::Security)
    end
  end

  describe '#account' do
    it 'returns a account' do
      expect(security.account).to be_a(Finary::User::Account)
    end
  end

  describe '#quantity' do
    it 'returns a float' do
      expect(security.quantity).to be_a(Float)
    end
  end

  describe '#current_value' do
    it 'returns a float' do
      expect(security.current_value).to be_a(Float)
    end
  end

  describe '#unrealized_pnl' do
    it 'returns a float' do
      expect(security.unrealized_pnl).to be_a(Float)
    end
  end

  describe '#unrealized_pnl_percent' do
    it 'returns a float' do
      expect(security.unrealized_pnl_percent).to be_a(Float)
    end
  end

  describe '#buying_price' do
    it 'returns a float' do
      expect(security.buying_price).to be_a(Float)
    end
  end

  describe '.all' do
    subject(:get_securities) do
      described_class.all
    end

    let(:finary_client) do
      instance_double(Finary::Client,
        get_user_securities: [security_attributes])
    end

    it 'uses the HTTP client' do
      get_securities

      expect(finary_client).to have_received(:get_user_securities)
    end

    it 'returns the security entries' do
      expect(get_securities).to match_array(
        [
          an_instance_of(described_class)
        ]
      )
    end
  end
end
