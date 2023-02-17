# frozen_string_literal: true

require 'nokogiri'

module Finary
  module Providers
    class Base
      attr_reader :account_name

      # Instanciate an Provider
      #
      # @param [String] account_name the user holding account name
      def initialize(account_name: nil)
        @account_name = account_name || self.class::PROVIDER_NAME
      end

      # Run the synchronization
      #
      # @param account_id [String] the account id
      # @param accout_name [String] the account name
      def sync!
        current_crowdlendings = build_current_crowdlendings

        investments.each do |crowdlending_attributes|
          if (crowdlending = current_crowdlendings.delete(crowdlending_attributes[:name]))
            Finary.logger.debug "Update crowdlending #{crowdlending_attributes[:name]}"
            crowdlending.update(crowdlending_attributes)
          else
            Finary.logger.debug "Add crowdlending #{crowdlending_attributes[:name]}"
            Finary::User::Crowdlending.create(full_attributes(crowdlending_attributes))
          end
        end

        clean_old_crowlendings(current_crowdlendings)
      end

      # The Provider investments
      #
      # @return [Array<Hash>] the Provider investments
      def investments
        @investments ||= build_investments
      end

      protected

      def account
        @account ||= find_or_create_account
      end

      def find_or_create_account
        fetch_account || create_account
      end

      def fetch_account
        Finary::User::Account.find(account_name, manual_type: 'crowdlending')
      end

      def create_account
        Finary::User::Account.create(
          name: account_name,
          manual_type: 'crowdlending',
          bank_account_type: {
            name: 'crowdlending'
          },
          currency: {
            code: 'EUR'
          }
        )
      end

      def full_attributes(attributes)
        {
          currency: { code: 'EUR' },
          account: { id: account.id }
        }.merge(attributes)
      end

      def build_current_crowdlendings
        account.crowdlendings.each_with_object({}) do |a, h|
          h[a.name] = a
        end
      end

      def clean_name(name)
        name.tr('&', '-')
      end

      def clean_old_crowlendings(old_crowlendings)
        old_crowlendings.each_value do |crowdlending|
          Finary.logger.debug "Remove crowdlending #{crowdlending.name}"
          crowdlending.delete
        end
      end
    end
  end
end
