# frozen_string_literal: true

module SolidusMultiVendor
  module Spree
    module Admin
      module StockLocationsControllerDecorator
        def self.prepended(base)
          base.before_action :set_vendor_id, only: [:create, :update]
        end
      end
    end
  end
end

Spree::Admin::StockLocationsController.prepend SolidusMultiVendor::Spree::Admin::StockLocationsControllerDecorator
