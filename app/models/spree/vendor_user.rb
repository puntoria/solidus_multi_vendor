# frozen_string_literal: true

module Spree
  class VendorUser < Spree::Base
    belongs_to :vendor, class_name: 'Spree::Vendor', optional: false
    belongs_to :user, class_name: Spree.user_class.name, optional: false, touch: true

    validates :vendor_id, uniqueness: { scope: :user_id }

    before_save :set_vendor_notification_email

    def set_vendor_notification_email
      return if vendor&.notification_email.present? || !vendor&.users&.empty?

      vendor.update_notification_email(user.email)
    end
  end
end
