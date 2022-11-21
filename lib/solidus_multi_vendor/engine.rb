# frozen_string_literal: true

require 'spree/core'
require 'solidus_multi_vendor'
require 'solidus_support'

module SolidusMultiVendor
  class Engine < Rails::Engine
    include ::SolidusSupport::EngineExtensions

    isolate_namespace ::Spree

    engine_name 'solidus_multi_vendor'

    # use rspec for tests
    config.generators do |g|
      g.test_framework :rspec
    end

    initializer "solidus_multi_vendor.register_vendor_abilities" do
      ::Spree::Ability.register_ability(::Spree::VendorAbility)
    end

    initializer 'solidus_multi_vendor.environment', before: :load_config_initializers do |_app|
      SolidusMultiVendor::Config = SolidusMultiVendor::Configuration.new
    end

    def self.activate
      Dir.glob(File.join(File.dirname(__FILE__), '../../app/**/*_decorator*.rb')).sort.each do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end
    end

    config.to_prepare(&method(:activate).to_proc)
  end
end
