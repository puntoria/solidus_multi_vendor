# frozen_string_literal: true

require 'solidus_core'
require 'solidus_multi_vendor/engine'
require 'solidus_multi_vendor/version'
require 'solidus_support'

module SolidusMultiVendor
  # TODO: this should be moved into preferences
  def self.vendorized_models
    SolidusMultiVendor::Config[:vendorized_models].map(&:classify).map do |class_name|
      "::Spree::#{class_name}".safe_constantize
    end.compact.uniq
  end
end
