# frozen_string_literal: true

require 'nokogiri'

module Finary
  module Providers
    class Base
      # Run the synchronization
      def sync(account_id:)
        current_crowdlendings = build_current_crowdlendings(account_id)

        investments.each do |crowdlending_attributes|
          if (crowdlending = current_crowdlendings.delete(crowdlending_attributes[:name]))
            Finary.logger.debug "Update crowdlending #{crowdlending_attributes[:name]}"
            crowdlending.update(crowdlending_attributes)
          else
            Finary.logger.debug "Add crowdlending #{crowdlending_attributes[:name]}"
            Finary::User::Crowdlending.create(full_attributes(crowdlending_attributes, account_id))
          end
        end

        current_crowdlendings.each_value do |crowdlending|
          Finary.logger.debug "Remove crowdlending #{crowdlending.name}"
          crowdlending.delete
        end
      end

      # The Provider investments
      #
      # @return [Array<Hash>] the Provider investments
      def investments
        @investments ||= build_investments
      end

      protected

      def full_attributes(attributes, account_id)
        {
          currency: { code: 'EUR' },
          account: { id: account_id }
        }.merge(attributes)
      end

      def build_current_crowdlendings(account_id)
        account = Finary::User::Account.get(account_id)

        account.crowdlendings.each_with_object({}) do |a, h|
          h[a.name] = a
        end
      end

      def clean_name(name)
        name.tr('&', '-')
      end
    end
  end
end
