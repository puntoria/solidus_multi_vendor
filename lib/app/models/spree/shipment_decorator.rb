# frozen_string_literal: true

module Spree
  module ShipmentDecorator
    def self.prepended(base)
      base.scope :for_vendor, ->(vendor) {
                                includes(stock_location: :vendor).where('spree_stock_locations.vendor_id' => vendor.id)
                              }
      base.scope :not_for_vendor, ->(vendor) {
                                    includes(stock_location: :vendor).where.not('spree_stock_locations.vendor_id' => vendor.id)
                                  }
    end
  end
end

Spree::Shipment.prepend Spree::ShipmentDecorator
