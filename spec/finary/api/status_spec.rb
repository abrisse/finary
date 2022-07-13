# frozen_string_literal: true

require 'spec_helper'

describe Finary::Status do
  subject(:status) do
    described_class.new(dasboard_attributes)
  end

  let(:dasboard_attributes) do
    load_json('finary', 'etc', 'status.json')
  end

  describe '#upnl' do
    it 'returns a float' do
      expect(status.upnl).to be_a(Float)
    end
  end

  describe '#share' do
    it 'returns a float' do
      expect(status.share).to be_a(Float)
    end
  end

  describe '#amount' do
    it 'returns a float' do
      expect(status.amount).to be_a(Float)
    end
  end

  describe '#evolution' do
    it 'returns a float' do
      expect(status.evolution).to be_a(Float)
    end
  end

  describe '#upnl_percent' do
    it 'returns a float' do
      expect(status.upnl_percent).to be_a(Float)
    end
  end

  describe '#evolution_percent' do
    it 'returns a float' do
      expect(status.evolution_percent).to be_a(Float)
    end
  end

  describe '#period_evolution' do
    it 'returns a float' do
      expect(status.period_evolution).to be_a(Float)
    end
  end

  describe '#period_evolution_percent' do
    it 'returns a float' do
      expect(status.period_evolution_percent).to be_a(Float)
    end
  end
end
