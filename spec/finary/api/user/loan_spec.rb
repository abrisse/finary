# frozen_string_literal: true

require 'spec_helper'

describe Finary::User::Loan do
  subject(:loan) do
    described_class.new(loan_attributes)
  end

  let(:loan_attributes) do
    load_json('user', 'loan.json')
  end

  let(:finary_client) do
    instance_double(Finary::Client)
  end

  before do
    allow(Finary).to receive(:client).and_return(finary_client)
  end

  describe '#id' do
    it 'returns an integer' do
      expect(loan.id).to be_a(Integer)
    end
  end

  describe '#name' do
    it 'returns a string' do
      expect(loan.name).to be_a(String)
    end
  end

  describe '#loan_type' do
    it 'returns a string' do
      expect(loan.loan_type).to be_a(String)
    end
  end

  describe '#loan_category' do
    it 'returns a string' do
      expect(loan.loan_category).to be_a(String)
    end
  end

  describe '#start_date' do
    it 'returns a date' do
      expect(loan.start_date).to be_a(Date)
    end
  end

  describe '#end_date' do
    it 'returns a date' do
      expect(loan.end_date).to be_a(Date)
    end
  end

  describe '#month_duration' do
    it 'returns an integer' do
      expect(loan.month_duration).to be_a(Integer)
    end
  end

  describe '#total_amount' do
    it 'returns an integer' do
      expect(loan.total_amount).to be_a(Integer)
    end
  end

  describe '#elapsed_months' do
    it 'returns an integer' do
      expect(loan.elapsed_months).to be_a(Integer)
    end
  end

  describe '#remaining_months' do
    it 'returns an integer' do
      expect(loan.remaining_months).to be_a(Integer)
    end
  end

  describe '#outstanding_capital' do
    it 'returns an integer' do
      expect(loan.outstanding_capital).to be_a(Integer)
    end
  end

  describe '#outstanding_amount' do
    it 'returns an integer' do
      expect(loan.outstanding_amount).to be_a(Integer)
    end
  end

  describe '#ownership_percentage' do
    it 'returns a float' do
      expect(loan.ownership_percentage).to be_a(Float)
    end
  end

  describe '#loan_to_value' do
    it 'returns a float' do
      expect(loan.loan_to_value).to be_a(Float)
    end
  end

  describe '#monthly_repayment' do
    it 'returns a float' do
      expect(loan.monthly_repayment).to be_a(Float)
    end
  end

  describe '#insurance_rate' do
    it 'returns a float' do
      expect(loan.insurance_rate).to be_a(Float)
    end
  end

  describe '#fixed_costs' do
    it 'returns a float' do
      expect(loan.fixed_costs).to be_a(Float)
    end
  end

  describe '#contribution' do
    it 'returns a float' do
      expect(loan.contribution).to be_a(Float)
    end
  end

  describe '.all' do
    subject(:get_loans) do
      described_class.all
    end

    let(:finary_client) do
      instance_double(Finary::Client, get_user_loans: [loan_attributes])
    end

    it 'uses the HTTP client' do
      get_loans

      expect(finary_client).to have_received(:get_user_loans)
    end

    it 'returns the loans' do
      expect(get_loans).to match_array(
        [
          an_instance_of(described_class)
        ]
      )
    end
  end
end
