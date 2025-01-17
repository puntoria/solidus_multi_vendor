# frozen_string_literal: true

module Spree
  module VendorConcern
    extend ActiveSupport::Concern

    included do
      belongs_to :vendor, class_name: 'Spree::Vendor', optional: true

      scope :with_vendor, ->(vendor_id) { where(vendor_id: vendor_id) }
    end
  end
end
