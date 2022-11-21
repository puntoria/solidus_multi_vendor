# frozen_string_literal: true

module SolidusMultiVendor
  module Spree
    module BaseDecorator
      SolidusMultiVendor.vendorized_models.each do |model|
        model.include ::Spree::VendorConcern

        if model.method_defined?(:whitelisted_ransackable_associations)
          if model.whitelisted_ransackable_associations
            model.whitelisted_ransackable_associations += %w[vendor]
          else
            model.whitelisted_ransackable_associations = %w[vendor]
          end
        end
      end
    end
  end
end
