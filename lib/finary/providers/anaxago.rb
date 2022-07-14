# frozen_string_literal: true

require 'csv'

module Finary
  module Providers
    class Anaxago
      attr_reader :path

      LABEL_MAPPING = {
        waiting: 'Investissements en attente',
        ongoing: 'Investissements en cours',
        finished: 'Investissements terminés'
      }.freeze

      # Instanciate an Anaxago Provider
      #
      # @param [String] path the CSV path
      def initialize(path)
        @path = path
      end

      # Run the synchronization
      def sync
        current_anaxago_assets = build_current_anaxago_assets

        investments.each do |asset_attributes|
          if (asset = current_anaxago_assets.delete(asset_attributes[:name]))
            Finary.logger.debug "Update generic asset #{asset_attributes[:name]}"
            asset.update(asset_attributes)
          else
            Finary.logger.debug "Add generic asset #{asset_attributes[:name]}"
            Finary::User::GenericAsset.create(asset_attributes)
          end
        end

        current_anaxago_assets.each_value do |asset|
          Finary.logger.debug "Remove generic asset #{asset.name}"
          asset.delete
        end
      end

      def investments
        ongoing_investments.concat(waiting_investments)
      end

      def ongoing_investments
        @ongoing_investments ||= build_investments(:ongoing)
      end

      def waiting_investments
        @waiting_investments ||= build_investments(:waiting)
      end

      private

      def build_investments(type)
        step = 0
        invests = []

        File.read(path).each_line do |line|
          case step
          when 0
            step += 1 if line.match?(/^#{LABEL_MAPPING[type]}$/)
          when 1..2
            step += 1
          when 3
            break if line.match?(/^$/)

            invests << parse_investment(line, type)
          end
        end

        invests
      end

      def parse_investment(str, type)
        parts = CSV.new(str).first

        attributes = {
          name: "[Anaxago] #{clean_name(parts[0])}",
          category: 'real_estate_crowdfunding',
          buying_price: 1
        }

        case type
        when :ongoing
          attributes.merge({
            quantity: parts[8].to_i,
            current_price: (parts[8].to_f + parts[9].to_f) / parts[8].to_f
          })
        when :waiting
          attributes.merge({
            quantity: parts[7].to_i,
            current_price: 1
          })
        end
      end

      def clean_name(name)
        name.tr('&', '-')
      end

      def build_current_anaxago_assets
        anaxago_assets = Finary::User::GenericAsset.all.keep_if do |a|
          a.name.start_with?('[Anaxago]')
        end

        anaxago_assets.each_with_object({}) do |a, h|
          h[a.name] = a
        end
      end
    end
  end
end
