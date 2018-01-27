require 'solidus_core'
require 'solidus_multi_vendor/engine'
require 'solidus_multi_vendor/version'
require 'solidus_support'

module SolidusMultiVendor
  # TODO: this should be moved into preferences
  def self.vendorized_models
    [
      Spree::OptionType,
      Spree::Product,
      Spree::Variant,
      Spree::Property,
      Spree::ShippingMethod,
      Spree::StockLocation
    ]
  end
end