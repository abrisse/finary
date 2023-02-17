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
      def initialize(phpsessid, **kargs)
        @phpsessid = phpsessid
        super(**kargs)
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

          annual_yield = xml_project
          .at_xpath('.//div[contains(@class, "preview")]//a//span/text()[2]').content.strip

          amount = xml_project
            .xpath('.//div[contains(@class, "bloc")]//strong/text()')[0]

          status = xml_project
            .xpath('.//div[@class="status"]//p/text()')[0]

          attributes = {
            amount: amount,
            name: name,
            annual_yield: annual_yield
          }

          build_investment(attributes) unless status.to_s == 'Remboursé'
        end.compact
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

      def build_investment(attributes)
        amount = attributes[:amount].text.tr('^[0-9]', '').to_i

        {
          name: clean_name(attributes[:name]),
          initial_investment: amount,
          current_price: amount,
          annual_yield: attributes[:annual_yield].delete(' %').to_f
        }
      end
    end
  end
end
