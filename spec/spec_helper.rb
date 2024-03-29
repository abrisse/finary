# frozen_string_literal: true

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', '..', 'lib'))

require 'simplecov'
require 'simplecov-lcov'

SimpleCov::Formatter::LcovFormatter.config.report_with_single_file = true

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new(
  [
    SimpleCov::Formatter::HTMLFormatter,
    SimpleCov::Formatter::LcovFormatter
  ]
)

SimpleCov.start do
  add_filter '.bundle/'
end

require 'finary'
require 'json'
require 'rspec'

module SpecHelper
  def fixture_path(*path)
    File.join(File.dirname(__FILE__), 'finary', 'etc', path)
  end

  def load_json(*path, symbolize_names: true)
    JSON.parse(File.read(fixture_path(*path)), symbolize_names:)
  end
end

shared_context 'common' do
  before do
    allow(Time).to receive(:now).and_return(Time.new(2023, 11, 18))
  end
end

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.include SpecHelper
  config.include_context 'common'
end
