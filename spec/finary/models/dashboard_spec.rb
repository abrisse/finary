require 'spec_helper'

describe Finary::Dashboard do
  let(:dasboard_attributes) do
    load_json('finary', 'etc', 'dashboard.json')
  end

  subject(:dashboard) do
    described_class.new(dasboard_attributes)
  end

  describe '#total' do
    it 'returns a status' do
      expect(dashboard.total).to be_an_instance_of(Finary::Status)
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
    it 'returns timeseries' do
      expect(dashboard.timeseries).to be_an_instance_of(Array)
    end
  end
end
