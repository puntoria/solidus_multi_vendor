# frozen_string_literal: true

# Configure Rails Environment
ENV['RAILS_ENV'] = 'test'

# Run Coverage report
require 'solidus_dev_support/rspec/coverage'

require File.expand_path('dummy/config/environment.rb', __dir__).tap { |file|
  # Create the dummy app if it's still missing.
  system 'bin/rake extension:test_app' unless File.exist? file
}
require 'pry'

# Requires factories and other useful helpers defined in spree_core.
require 'solidus_dev_support/rspec/feature_helper'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[File.join(File.dirname(__FILE__), 'support/**/*.rb')].sort.each { |f| require f }

RSpec.configure do |config|
  config.infer_spec_type_from_file_location!
  config.use_transactional_fixtures = false

  config.include Devise::TestHelpers, type: :controller
  config.include Warden::Test::Helpers
end
