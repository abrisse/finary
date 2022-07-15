# frozen_string_literal: true

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', '..', 'lib'))

require 'coveralls'
require 'simplecov'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter
]

SimpleCov.start do
  add_filter '.bundle/'
end

require 'finary'
require 'json'
require 'pp'
require 'rspec'

module SpecHelper
  def fixture_path(*path)
    File.join(File.dirname(__FILE__), 'finary', 'etc', path)
  end

  def load_json(*path, symbolize_names: true)
    JSON.parse(File.read(fixture_path(*path)), symbolize_names: symbolize_names)
  end
end

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.include SpecHelper
end
