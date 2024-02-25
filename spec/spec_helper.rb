# frozen_string_literal: true

require 'simplecov'
SimpleCov.start

require 'rspec'

require_relative '../app'
require_relative 'support/test_helpers'

['../services/**/*.rb', '../lib/**/*.rb'].each do |path|
  Dir[File.join(File.dirname(__FILE__), path)].sort.each do |file|
    require file
  end
end

RSpec.configure do |config|
  config.include TestHelpers

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_framework = :rspec
  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
end
