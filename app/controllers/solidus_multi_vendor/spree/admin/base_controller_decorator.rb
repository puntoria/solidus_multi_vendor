# frozen_string_literal: true

module SolidusMultiVendor
  module Spree
    module Admin
      module BaseControllerDecorator
        ::Spree::Admin::BaseController.include(::Spree::Admin::VendorHelper)

        def self.prepended(base)
          base.helper_method :current_spree_vendor
          base.helper_method :vendor_state_options
        end
      end
    end
  end
end

Spree::Admin::BaseController.prepend SolidusMultiVendor::Spree::Admin::BaseControllerDecorator
