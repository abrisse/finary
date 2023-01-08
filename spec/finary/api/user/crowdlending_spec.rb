# frozen_string_literal: true

require 'spec_helper'

describe Finary::User::Crowdlending do
  subject(:crowdlending) do
    described_class.new(crowdlending_attributes)
  end

  let(:crowdlending_attributes) do
    load_json('user', 'crowdlending.json')
  end

  let(:finary_client) do
    instance_double(Finary::Client)
  end

  before do
    allow(Finary).to receive(:client).and_return(finary_client)
  end

  describe '#id' do
    it 'returns a string' do
      expect(crowdlending.id).to be_a(String)
    end
  end

  describe '#name' do
    it 'returns a string' do
      expect(crowdlending.name).to be_a(String)
    end
  end

  describe '#initial_investment' do
    it 'returns a float' do
      expect(crowdlending.initial_investment).to be_a(Float)
    end
  end

  describe '#current_value' do
    it 'returns a float' do
      expect(crowdlending.current_value).to be_a(Float)
    end
  end

  describe '#current_price' do
    it 'returns a float' do
      expect(crowdlending.current_price).to be_a(Float)
    end
  end

  describe '#month_duration' do
    it 'returns a float' do
      expect(crowdlending.month_duration).to be_a(Integer)
    end
  end

  describe '#annual_yield' do
    it 'returns a float' do
      expect(crowdlending.annual_yield).to be_a(Float)
    end
  end

  describe '#start_date' do
    it 'returns a float' do
      expect(crowdlending.start_date).to be_a(Date)
    end
  end

  describe '.all' do
    subject(:all_crowdlendings) do
      described_class.all
    end

    let(:finary_client) do
      instance_double(Finary::Client, get_user_crowdlendings: [crowdlending_attributes])
    end

    it 'uses the HTTP client' do
      all_crowdlendings

      expect(finary_client).to have_received(:get_user_crowdlendings)
    end

    it 'returns the generic assets' do
      expect(all_crowdlendings).to match_array(
        [
          an_instance_of(described_class)
        ]
      )
    end
  end

  describe '.get' do
    subject(:get_crowdlending) do
      described_class.get('f78687d5-3cae-4005-8d13-8db97f1361c8')
    end

    let(:finary_client) do
      instance_double(Finary::Client, get_user_crowdlending: crowdlending_attributes)
    end

    it 'uses the HTTP client' do
      get_crowdlending

      expect(finary_client).to have_received(:get_user_crowdlending).with('f78687d5-3cae-4005-8d13-8db97f1361c8')
    end

    it 'returns the generic asset' do
      expect(get_crowdlending).to be_an_instance_of(described_class)
    end
  end

  describe '.create' do
    subject(:create_crowdlending) do
      described_class.create(params)
    end

    let(:params) do
      {
        currency: { code: 'EUR' },
        account: { id: '123' },
        name: 'The Project',
        initial_investment: 1000,
        current_price: 1000,
        annual_yield: 10,
        month_duration: 24
      }
    end

    let(:finary_client) do
      instance_double(Finary::Client, add_user_crowdlending: crowdlending_attributes)
    end

    it 'uses the HTTP client' do
      create_crowdlending

      expect(finary_client).to have_received(:add_user_crowdlending).with(params)
    end

    it 'returns the generic asset' do
      expect(create_crowdlending).to be_an_instance_of(described_class)
    end
  end

  describe '#update' do
    subject(:update_crowdlending) do
      crowdlending.update(params)
    end

    let(:params) do
      {
        current_price: 1200
      }
    end

    let(:finary_client) do
      instance_double(Finary::Client, update_user_crowdlending: crowdlending_attributes)
    end

    it 'uses the HTTP client' do
      update_crowdlending

      expect(finary_client)
        .to have_received(:update_user_crowdlending)
        .with('f78687d5-3cae-4005-8d13-8db97f1361c8', params)
    end

    it 'returns the generic asset' do
      expect(update_crowdlending).to be_an_instance_of(described_class)
    end
  end

  describe '#delete' do
    subject(:delete_crowdlending) do
      crowdlending.delete
    end

    let(:finary_client) do
      instance_double(Finary::Client, delete_user_crowdlending: true)
    end

    it 'uses the HTTP client' do
      delete_crowdlending

      expect(finary_client)
        .to have_received(:delete_user_crowdlending)
        .with('f78687d5-3cae-4005-8d13-8db97f1361c8')
    end

    it 'returns the generic asset' do
      expect(delete_crowdlending).to be_truthy
    end
  end
end
