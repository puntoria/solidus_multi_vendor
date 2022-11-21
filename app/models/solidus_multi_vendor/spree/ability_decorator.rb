# frozen_string_literal: true

module SolidusMultiVendor
  module Spree
    module AbilityDecorator
      private

      def abilities_to_register
        super << Spree::VendorAbility
      end
    end
  end
end

Spree::Ability.prepend SolidusMultiVendor::Spree::AbilityDecorator
