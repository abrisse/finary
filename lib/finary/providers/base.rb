# frozen_string_literal: true

require 'nokogiri'

module Finary
  module Providers
    class Base
      # Run the synchronization
      def sync
        current_assets = build_current_assets

        investments.each do |asset_attributes|
          if (asset = current_assets.delete(asset_attributes[:name]))
            Finary.logger.debug "Update generic asset #{asset_attributes[:name]}"
            asset.update(asset_attributes)
          else
            Finary.logger.debug "Add generic asset #{asset_attributes[:name]}"
            Finary::User::GenericAsset.create(asset_attributes)
          end
        end

        current_assets.each_value do |asset|
          Finary.logger.debug "Remove generic asset #{asset.name}"
          asset.delete
        end
      end

      # The Provider investments
      #
      # @return [Array<Hash>] the Provider investments
      def investments
        @investments ||= build_investments
      end

      protected

      def build_current_assets
        assets = Finary::User::GenericAsset.all.keep_if do |a|
          a.name.start_with?(prefix)
        end

        assets.each_with_object({}) do |a, h|
          h[a.name] = a
        end
      end

      def prefix
        "[#{self.class::PROVIDER_NAME}]"
      end

      def clean_name(name)
        name.tr('&', '-')
      end
    end
  end
end
