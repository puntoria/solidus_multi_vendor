# frozen_string_literal: true

module Spree
  module Admin
    module OptionTypesControllerDecorator
      def self.prepended(base)
        base.before_action :set_vendor_id, only: [:create, :update]
      end
    end
  end
end

Spree::Admin::OptionTypesController.prepend Spree::Admin::OptionTypesControllerDecorator
