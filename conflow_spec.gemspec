# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "conflow_spec/version"

Gem::Specification.new do |spec|
  spec.name          = "conflow_spec"
  spec.version       = ConflowSpec::VERSION
  spec.authors       = ["Michał Begejowicz"]
  spec.email         = ["michal.begejowicz@codesthq.com"]

  spec.required_ruby_version = "~> 2.3"

  spec.summary       = "Helpers for testing flows in RSpec"
  spec.description   = "Helpers for testing flows in RSpec"
  spec.homepage      = "https://github.com/fanfilmu/conflow_spec"
  spec.license       = "MIT"

  spec.files = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^spec/}) }
  spec.require_paths = ["lib"]

  spec.add_dependency "conflow", "~> 0.4"
  spec.add_dependency "rspec", "~> 3.0"

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "pry", "~> 0.11"
  spec.add_development_dependency "rake", "~> 12.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rubocop", "~> 0.51"
  spec.add_development_dependency "simplecov", "~> 0.15"
end
