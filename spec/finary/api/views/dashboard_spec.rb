# frozen_string_literal: true

require 'spec_helper'

describe Finary::Views::Dashboard do
  subject(:dashboard) do
    described_class.new(dasboard_attributes)
  end

  let(:dasboard_attributes) do
    load_json('finary', 'etc', 'views', 'dashboard.json')
  end

  describe '#last_user_sync_at' do
    it 'returns a date' do
      expect(dashboard.last_user_sync_at).to be_a(Date)
    end
  end

  describe '#total' do
    it 'returns a status' do
      expect(dashboard.total).to be_a(Finary::Status)
    end
  end

  describe '#distribution' do
    it 'returns a hash of status' do
      expect(dashboard.distribution).to match(
        hash_including(
          checking_accounts: an_instance_of(Finary::Status),
          savings_accounts: an_instance_of(Finary::Status)
        )
      )
    end
  end

  describe '#timeseries' do
    it 'returns an array' do
      expect(dashboard.timeseries).to be_a(Array)
    end
  end
end
