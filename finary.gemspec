# frozen_string_literal: true

Gem::Specification.new do |gem|
  gem.authors       = ['Aymeric Brisse']
  gem.email         = ['aymeric.brisse@gmail.com']
  gem.description   = 'Finary API wrapper'
  gem.summary       = 'Finary allows you to manipulate directly the Finary API, which is not officially released yet.'
  gem.homepage      = 'https://github.com/abrisse/finary'
  gem.license       = 'MIT'
  gem.files         = `git ls-files`.split($OUTPUT_RECORD_SEPARATOR)
  gem.executables   = gem.files.grep(%r{^bin/}).map { |f| File.basename(f) }
  gem.name          = 'finary'
  gem.require_paths = ['lib']
  gem.version       = '0.0.1'

  gem.add_dependency('dry-struct', '~> 1.4')
  gem.add_dependency('httparty', '~> 0.20')
  gem.add_dependency('irb', '~> 1.4')
  gem.add_dependency('mongoid', '>= 6', '< 8')
  gem.add_dependency('nokogiri', '~> 1', '>= 1.13.9')
  gem.add_dependency('rake', '~> 13')

  gem.metadata['rubygems_mfa_required'] = 'true'
end
