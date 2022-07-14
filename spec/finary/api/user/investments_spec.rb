# frozen_string_literal: true

require 'spec_helper'

describe Finary::User::Investments do
  subject(:investments) do
    described_class.new(dasboard_attributes)
  end

  let(:dasboard_attributes) do
    load_json('user', 'investments.json')
  end

  describe '#total' do
    it 'returns a status' do
      expect(investments.total).to be_a(Finary::Status)
    end
  end

  describe '#accounts' do
    it 'returns an array of accounts' do
      expect(investments.accounts).to match_array(
        [
          an_instance_of(Finary::User::Account),
          an_instance_of(Finary::User::Account)
        ]
      )
    end
  end
end
