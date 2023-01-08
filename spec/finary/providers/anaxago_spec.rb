# frozen_string_literal: true

require 'spec_helper'

describe Finary::Providers::Anaxago do
  subject(:anaxago) do
    described_class.new(path)
  end

  let(:path) do
    fixture_path('providers', 'anaxago.csv')
  end

  describe '#sync' do
    subject(:sync) do
      anaxago.sync(account_id: account_id)
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
      Finary::User::Crowdlending.new(crowdlending_attributes.merge(name: 'Opé B'))
    end

    let(:crowdlending_to_delete) do
      Finary::User::Crowdlending.new(crowdlending_attributes.merge(name: 'Opé Z'))
    end

    let(:crowdlending_attributes) do
      load_json('user', 'crowdlending.json')
    end

    it 'adds the new ongoing crowdlendings' do
      sync

      expect(Finary::User::Crowdlending)
        .to have_received(:create)
        .with(hash_including(name: 'Opé C'))
    end

    it 'adds the new waiting crowdlendings' do
      sync

      expect(Finary::User::Crowdlending)
        .to have_received(:create)
        .with(hash_including(name: 'Opé E'))
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

  describe '#ongoing_investments' do
    subject(:ongoing_investments) do
      anaxago.ongoing_investments
    end

    it 'returns the ongoing investments' do
      expect(ongoing_investments).to match_array(
        [
          {
            name: 'Opé B',
            annual_yield: 11.0,
            start_date: Date.parse('2020-06-19'),
            initial_investment: 1663,
            current_price: 2195.07
          },
          {
            name: 'Opé C',
            annual_yield: 9.0,
            start_date: Date.parse('2023-01-16'),
            initial_investment: 1475,
            current_price: 1907.85
          }
        ]
      )
    end
  end

  describe '#waiting_investments' do
    subject(:waiting_investments) do
      anaxago.waiting_investments
    end

    it 'returns the waiting investments' do
      expect(waiting_investments).to match_array(
        [
          {
            name: 'Opé E',
            annual_yield: 10.0,
            start_date: Date.parse('2022-09-01'),
            initial_investment: 2000.0,
            current_price: 2000.0
          }
        ]
      )
    end
  end
end
