# frozen_string_literal: true

require 'nokogiri'

module Finary
  module Providers
    class Homunity
      attr_reader :phpsessid

      # Instanciate a Homunity Provider
      #
      # @param [String] path the PHPSESSID value stored in the web cookie
      def initialize(phpsessid)
        @phpsessid = phpsessid
      end

      # Run the synchronization
      def sync
        current_homunity_assets = build_current_homunity_assets

        investments.each do |asset_attributes|
          if (asset = current_homunity_assets.delete(asset_attributes[:name]))
            Finary.logger.debug "Update generic asset #{asset_attributes[:name]}"
            asset.update(asset_attributes)
          else
            Finary.logger.debug "Add generic asset #{asset_attributes[:name]}"
            Finary::User::GenericAsset.create(asset_attributes)
          end
        end

        current_homunity_assets.each_value do |asset|
          Finary.logger.debug "Remove generic asset #{asset.name}"
          asset.delete
        end
      end

      # Retrieve and return the Homunity investments
      #
      # @return [Array<Hash>] the Homunity investments
      def investments
        @investments ||= build_investments
      end

      private

      def build_investments
        page = 1
        invests = []

        while (invests_page = retrieve_page_projects(page)).any?
          invests.concat(invests_page)
          page += 1
        end

        invests
      end

      def retrieve_page_projects(page)
        html = HTTParty.get("https://www.homunity.com/fr/user/projects?page=#{page}",
          headers: common_headers).body

        parsed_data = Nokogiri::HTML.parse(html)

        parsed_data.xpath('//*[@id="projects"]/div[contains(@class, "invest")]').map do |xml_project|
          name = xml_project
            .at_xpath('.//div[contains(@class, "preview")]//span[contains(@class, "name")]/@title')
            .value

          amount = xml_project
            .xpath('.//div[contains(@class, "bloc")]//strong/text()')[0]

          build_investment(name, amount)
        end
      end

      def common_headers
        cookie_hash = HTTParty::CookieHash.new
        cookie_hash.add_cookies("PHPSESSID=#{phpsessid}")

        {
          'cookie' => cookie_hash.to_cookie_string
        }
      end

      def build_investment(label, amount)
        amount = amount.text.tr('^[0-9]', '').to_i

        {
          name: "[Homunity] #{clean_name(label)}",
          category: 'real_estate_crowdfunding',
          buying_price: 1_000,
          quantity: amount / 1_000,
          current_price: 1_000
        }
      end

      def clean_name(name)
        name.tr('&', '-')
      end

      def build_current_homunity_assets
        homunity_assets = Finary::User::GenericAsset.all.keep_if do |a|
          a.name.start_with?('[Homunity]')
        end

        homunity_assets.each_with_object({}) do |a, h|
          h[a.name] = a
        end
      end
    end
  end
end
