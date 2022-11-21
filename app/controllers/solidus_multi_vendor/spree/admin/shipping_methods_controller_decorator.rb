# frozen_string_literal: true

module SolidusMultiVendor
  module Spree
    module Admin
      module ShippingMethodsControllerDecorator
        def self.prepended(base)
          base.before_action :set_vendor_id, only: [:create, :update]
        end
      end
    end
  end
end

Spree::Admin::ShippingMethodsController.prepend SolidusMultiVendor::Spree::Admin::ShippingMethodsControllerDecorator
