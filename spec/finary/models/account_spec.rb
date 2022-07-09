require 'spec_helper'

describe Finary::Account do
  let(:account_attributes) do
    load_json('finary', 'etc', 'account.json')
  end

  subject(:account) do
    described_class.new(account_attributes)
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

  describe '#display_upnl' do
    it 'returns a float' do
      expect(account.display_upnl).to be_a(Float)
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

  describe '#display_unrealized_pnl' do
    it 'returns a float' do
      expect(account.display_unrealized_pnl).to be_a(Float)
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
          an_instance_of(Finary::SecurityEntry)
        ]
      )
    end
  end
end
