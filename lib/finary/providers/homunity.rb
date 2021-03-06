# frozen_string_literal: true

require 'nokogiri'

module Finary
  module Providers
    class Homunity < Base
      attr_reader :phpsessid

      PROVIDER_NAME = 'Homunity'

      # Instanciate a Homunity Provider
      #
      # @param [String] path the PHPSESSID value stored in the web cookie
      def initialize(phpsessid)
        @phpsessid = phpsessid
        super()
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
        html = get_page_projects(page)

        html.xpath('//*[@id="projects"]/div[contains(@class, "invest")]').map do |xml_project|
          name = xml_project
            .at_xpath('.//div[contains(@class, "preview")]//span[contains(@class, "name")]/@title')
            .value

          amount = xml_project
            .xpath('.//div[contains(@class, "bloc")]//strong/text()')[0]

          build_investment(name, amount)
        end
      end

      def get_page_projects(page)
        response = HTTParty.get(
          "https://www.homunity.com/fr/user/projects?page=#{page}",
          headers: common_headers
        )

        html = Nokogiri::HTML.parse(response.body)

        if html.at_xpath('//*[@id="login"]')
          Finary.logger.debug '[Homunity] Invalid or expired PHPSESSID'

          raise StandardError, '[Homunity] Invalid or expired PHPSESSID'
        end

        html
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
          name: [prefix, clean_name(label)].join(' '),
          category: 'real_estate_crowdfunding',
          buying_price: 1_000,
          quantity: amount / 1_000,
          current_price: 1_000
        }
      end
    end
  end
end
