# frozen_string_literal: true

module Spree
  module AbilityDecorator
    private

    def abilities_to_register
      super << Spree::VendorAbility
    end
  end
end

Spree::Ability.prepend Spree::AbilityDecorator
