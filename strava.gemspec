$: << File.expand_path('../lib', __FILE__)
require 'strava/version'

Gem::Specification.new do |s|
  s.name        = 'strava-cli'
  s.licenses    = ['MIT']
  s.version     = Strava::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Paul Bonaud']
  s.email       = ['paul@bonaud.fr']
  s.homepage    = 'https://rubygems.org/gems/strava-cli'
  s.summary     = %q(Generate strava dashboards.)
  s.description = %q(Generate strava dashboards.)

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  s.require_paths = ['lib']

  s.required_ruby_version = '>= 2.2.2'

  s.add_dependency 'easy_app_helper'
  s.add_dependency 'vcr'
  s.add_dependency 'hashie'
  s.add_dependency 'strava-api-v3'
  s.add_dependency 'terminal-table'

  s.add_development_dependency 'pry'
  s.add_development_dependency 'guard'
  s.add_development_dependency 'guard-rspec'
  s.add_development_dependency 'guard-rubocop'
  s.add_development_dependency 'rubocop'
  s.add_development_dependency 'ci_reporter'
  s.add_development_dependency 'ci_reporter_rspec'
  s.add_development_dependency 'rack-test'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'rspec-its'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'simplecov-rcov'
  s.add_development_dependency 'timecop'
  s.add_development_dependency 'webmock'
end
