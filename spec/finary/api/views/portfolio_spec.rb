# frozen_string_literal: true

require 'spec_helper'

describe Finary::Views::Portfolio do
  subject(:portfolio) do
    described_class.new(portfolio_attributes)
  end

  let(:portfolio_attributes) do
    load_json('finary', 'etc', 'views', 'portfolio.json')
  end

  describe '#last_user_sync_at' do
    it 'returns a date' do
      expect(portfolio.last_user_sync_at).to be_a(Date)
    end
  end

  describe '#data' do
    it 'returns a data' do
      expect(portfolio.data).to be_a(Finary::Views::Data)
    end
  end

  describe '#timeseries' do
    it 'returns an array' do
      expect(portfolio.timeseries).to be_a(Array)
    end
  end
end
