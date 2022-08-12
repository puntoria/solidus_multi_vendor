# frozen_string_literal: true

module Spree
  module Stock
    module PackageDecorator
      def shipping_methods
        if (vendor = stock_location.vendor)
          vendor.shipping_methods.to_a
        else
          shipping_categories.map(&:shipping_methods).reduce(:&).to_a
        end
      end
    end
  end
end

Spree::Stock::Package.prepend Spree::Stock::PackageDecorator
