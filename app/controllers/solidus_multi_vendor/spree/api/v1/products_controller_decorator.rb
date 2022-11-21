# frozen_string_literal: true

module SolidusMultiVendor
  module Spree
    module Api
      module V1
        module ProductsControllerDecorator
          def self.prepended(base)
            base.before_action only: [:create, :update] do
              set_vendor_id(:product)
            end
          end
        end
      end
    end
  end
end

::Spree::Api::ProductsController.prepend SolidusMultiVendor::Spree::Api::V1::ProductsControllerDecorator
