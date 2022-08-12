# frozen_string_literal: true

module Spree
  module Admin
    module VariantsControllerDecorator
      def self.prepended(base)
        base.before_action :set_vendor_id, only: [:create, :update]
      end
    end
  end
end

Spree::Admin::VariantsController.prepend Spree::Admin::VariantsControllerDecorator
