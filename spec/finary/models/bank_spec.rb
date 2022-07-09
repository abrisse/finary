require 'spec_helper'

describe Finary::Bank do
  let(:bank_attributes) do
    load_json('finary', 'etc', 'bank.json')
  end

  subject(:bank) do
    described_class.new(bank_attributes)
  end

  describe '#id' do
    it 'returns a string' do
      expect(bank.id).to be_a(String)
    end
  end

  describe '#slug' do
    it 'returns a string' do
      expect(bank.slug).to be_a(String)
    end
  end

  describe '#name' do
    it 'returns a string' do
      expect(bank.name).to be_a(String)
    end
  end

  describe '#twitter_handle' do
    it 'returns a string' do
      expect(bank.twitter_handle).to be_a(String)
    end
  end

  describe '#logo_url' do
    it 'returns a string' do
      expect(bank.logo_url).to be_a(String)
    end
  end

  describe '#countries' do
    it 'returns an array of strings' do
      expect(bank.countries).to match_array(an_instance_of(String))
    end
  end

  describe '#is_requestable' do
    it 'returns a boolean' do
      expect([true, false]).to include(bank.is_requestable)
    end
  end
end
