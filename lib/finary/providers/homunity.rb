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

        html.xpath('//div[@class="bg-white rounded-xl overflow-hidden shadow-sm"]').filter_map do |xml_project|
          name = xml_project
            .at_xpath('.//h3[@class="font-sans"]//a/text()').content.strip

          annual_yield = parse_number(
            xml_project.at_xpath('.//dd[@class="font-bold col-span-2"]//text()').content
          )

          month_duration = parse_number(
            xml_project.at_xpath('.//dd[@class="font-bold col-span-3"]//text()').content
          )

          amount = xml_project
            .xpath('.//p[@class="mb-2"]//strong/text()')[0]

          status = xml_project
            .xpath('.//div[@class="w-full"]//div[@class="mb-4"]//p//text()')[0].content.include?('Remboursement prévu')

          attributes = {
            amount:,
            name:,
            annual_yield:,
            month_duration:
          }

          build_investment(attributes) if status
        end
      end

      def parse_number(str)
        str.match(/[\d.]+/)[0]
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
          annual_yield: attributes[:annual_yield].delete(' %').to_f,
          month_duration: attributes[:month_duration]
        }
      end
    end
  end
end
