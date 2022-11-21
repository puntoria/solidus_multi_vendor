# frozen_string_literal: true

module SolidusMultiVendor
  module Spree
    module UserDecorator
      def self.prepended(base)
        base.has_many :vendor_users, class_name: 'Spree::VendorUser'
        base.has_many :vendors, through: :vendor_users, class_name: 'Spree::Vendor'
      end
    end
  end
end

Spree.user_class.prepend SolidusMultiVendor::Spree::UserDecorator