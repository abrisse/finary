# frozen_string_literal: true

require 'spec_helper'

describe Finary::User::Views do
  before do
    allow(Finary).to receive(:client).and_return(finary_client)
  end

  let(:finary_client) do
    instance_double(Finary::Client)
  end

  describe '.dashboard' do
    subject(:dashboard) do
      described_class.dashboard(type: 'gross', period: 'ytd')
    end

    let(:finary_client) do
      instance_double(Finary::Client, get_user_view: attributes)
    end

    let(:attributes) do
      load_json('user', 'views', 'dashboard.json')
    end

    it 'uses the HTTP client' do
      dashboard

      expect(finary_client).to have_received(:get_user_view).with(:dashboard, type: 'gross', period: 'ytd')
    end

    it 'returns the dashboard' do
      expect(dashboard).to be_a(Finary::User::Views::Dashboard)
    end
  end

  describe '.portfolio' do
    subject(:portfolio) do
      described_class.portfolio(period: 'ytd')
    end

    let(:finary_client) do
      instance_double(Finary::Client, get_user_view: attributes)
    end

    let(:attributes) do
      load_json('user', 'views', 'portfolio.json')
    end

    it 'uses the HTTP client' do
      portfolio

      expect(finary_client).to have_received(:get_user_view).with(:portfolio, period: 'ytd')
    end

    it 'returns the portfolio' do
      expect(portfolio).to be_a(Finary::User::Views::Portfolio)
    end
  end
end
