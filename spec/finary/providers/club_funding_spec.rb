# frozen_string_literal: true

require 'spec_helper'

describe Finary::Providers::ClubFunding do
  subject(:club_funding) do
    described_class.new(
      email: 'john.doe@gmail.com',
      password: '12345',
      account_name: account_name
    )
  end

  let(:account_name) do
    'Club Funding'
  end

  let(:get_ongoing_investments) do
    load_json('providers', 'club_funding.json')
  end

  let(:club_funding_client) do
    instance_double(
      Finary::Providers::ClubFunding::Client, get_ongoing_investments: get_ongoing_investments
    )
  end

  before do
    allow(Finary::Providers::ClubFunding::Client).to receive(:new).and_return(club_funding_client)
  end

  describe '#sync!' do
    subject(:sync) do
      club_funding.sync!
    end

    before do
      allow(Finary::User::Account).to receive(:find).with(
        account_name,
        manual_type: 'crowdlending'
      ).and_return(account)

      allow(Finary::User::Crowdlending).to receive(:create).and_return(random_crowdlending)

      allow(crowdlending_to_update).to receive(:update)
      allow(crowdlending_to_delete).to receive(:delete)
    end

    let(:account) do
      instance_double(Finary::User::Account, id: account_id, crowdlendings: current_crowdlendings)
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
      Finary::User::Crowdlending.new(crowdlending_attributes.merge(name: 'Opé A'))
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
        .with(hash_including(name: 'Opé B'))
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
      club_funding.investments
    end

    it 'returns the investments' do
      expect(investments).to match_array(
        [
          {
            name: 'Opé A',
            annual_yield: 10.5,
            month_duration: 9,
            start_date: Date.parse('29/06/2022'),
            current_price: 2_000,
            initial_investment: 2_000
          },
          {
            name: 'Opé B',
            annual_yield: 11.0,
            month_duration: 24,
            start_date: Date.parse('13/07/2022'),
            current_price: 1_000,
            initial_investment: 1_000
          }
        ]
      )
    end
  end
end
