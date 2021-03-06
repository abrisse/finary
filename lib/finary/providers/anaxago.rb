# frozen_string_literal: true

require 'csv'

module Finary
  module Providers
    class Anaxago < Base
      attr_reader :path

      LABEL_MAPPING = {
        waiting: 'Investissements en attente',
        ongoing: 'Investissements en cours',
        finished: 'Investissements terminés'
      }.freeze

      PROVIDER_NAME = 'Anaxago'

      # Instanciate an Anaxago Provider
      #
      # @param [String] path the CSV path
      def initialize(path)
        @path = path
        super()
      end

      # The ongoing Anaxago investments
      #
      # @return [Array<Hash>] the Anaxago investments
      def ongoing_investments
        build_anaxago_investments(:ongoing)
      end

      # The waiting Anaxago investments
      #
      # @return [Array<Hash>] the Anaxago investments
      def waiting_investments
        build_anaxago_investments(:waiting)
      end

      private

      def build_investments
        ongoing_investments + waiting_investments
      end

      def build_anaxago_investments(type)
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
          name: [prefix, clean_name(parts[0])].join(' '),
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
    end
  end
end
