# frozen_string_literal: true

module Spree
  module Stock
    module PackageDecorator
      Spree::Stock::Package.include SolidusMultiVendor::Stock::PackageConcern
    end
  end
end
