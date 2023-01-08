# frozen_string_literal: true

require 'spec_helper'

describe Finary::Providers::Homunity do
  subject(:homunity) do
    described_class.new('phpsessid')
  end

  let(:body_response) do
    File.read(fixture_path('providers', 'homunity.html'))
  end

  let(:response) do
    instance_double(HTTParty::Response, body: body_response)
  end

  let(:empty_response) do
    instance_double(HTTParty::Response, body: '<html></html>')
  end

  before do
    allow(HTTParty).to receive(:get).and_return(response, empty_response)
  end

  describe '#sync' do
    subject(:sync) do
      homunity.sync(account_id: account_id)
    end

    before do
      allow(Finary::User::Account).to receive(:get).with(account_id).and_return(account)
      allow(Finary::User::Crowdlending).to receive(:create).and_return(random_crowdlending)

      allow(crowdlending_to_update).to receive(:update)
      allow(crowdlending_to_delete).to receive(:delete)
    end

    let(:account) do
      instance_double(Finary::User::Account, crowdlendings: current_crowdlendings)
    end

    let(:account_id) do
      'd2b7f41b-2dc5-4132-83fd-cd0a409c4f6e'
    end

    let(:current_crowdlendings) do
      [
        crowdlending_to_update,
        crowdlending_to_delete
      ]
    end

    let(:random_crowdlending) do
      Finary::User::Crowdlending.new(crowdlending_attributes)
    end

    let(:crowdlending_to_update) do
      Finary::User::Crowdlending.new(crowdlending_attributes.merge(name: 'Morel Lodge'))
    end

    let(:crowdlending_to_delete) do
      Finary::User::Crowdlending.new(crowdlending_attributes.merge(name: 'Opé Z'))
    end

    let(:crowdlending_attributes) do
      load_json('user', 'crowdlending.json')
    end

    it 'adds the new crowdlendings' do
      sync

      expect(Finary::User::Crowdlending)
        .to have_received(:create)
        .with(hash_including(name: 'Les Pleiades'))
    end

    it 'updates the current crowdlendings' do
      sync

      expect(crowdlending_to_update).to have_received(:update)
    end

    it 'removes the legacy crowdlendings' do
      sync

      expect(crowdlending_to_delete).to have_received(:delete)
    end
  end

  describe '#investments' do
    subject(:investments) do
      homunity.investments
    end

    it 'returns the investments' do
      expect(investments).to match_array(
        [
          {
            name: 'Les Pleiades',
            initial_investment: 2000,
            current_price: 2000
          },
          {
            name: 'Morel Lodge',
            initial_investment: 2000,
            current_price: 2000
          }
        ]
      )
    end
  end
end
