# frozen_string_literal: true

module Spree
  class OrderCommission < Base
    belongs_to :order, optional: false
    belongs_to :vendor, optional: false

    validates :order, :vendor, presence: true
    validates :vendor_id, uniqueness: { scope: :order_id }

    scope :for_vendor, ->(vendor) { where(vendor_id: vendor.id) }
  end
end
