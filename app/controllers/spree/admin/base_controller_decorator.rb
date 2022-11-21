# frozen_string_literal: true

module Spree
  module Admin
    module BaseControllerDecorator
      Spree::Admin::BaseController.include(Spree::Admin::VendorHelper)

      def self.prepended(base)
        base.helper_method :current_spree_vendor
      end
    end
  end
end

Spree::Admin::BaseController.prepend Spree::Admin::BaseControllerDecorator
