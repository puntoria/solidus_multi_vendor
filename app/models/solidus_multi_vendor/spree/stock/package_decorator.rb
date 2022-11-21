# frozen_string_literal: true

module SolidusMultiVendor
  module Spree
    module Stock
      module PackageDecorator
        def shipping_methods
          vendor = Spree::StockLocation.method_defined?(:vendor) ? stock_location.vendor : nil

          # return only shipping methods for this Vendor
          if vendor && Spree::ShippingMethod.method_defined?(:vendor)
            vendor.shipping_methods.to_a
          else
            shipping_categories.map(&:shipping_methods).reduce(:&).to_a
          end
        end
      end
    end
  end
end

Spree::Stock::Package.prepend SolidusMultiVendor::Spree::Stock::PackageDecorator
