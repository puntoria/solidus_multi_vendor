# frozen_string_literal: true

module SolidusMultiVendor
  module Spree
    module Api
      module ApiHelpersDecorator
        def self.prepended(base)
          base::ATTRIBUTES.push(:vendor_attributes)

          base.mattr_reader(*base::ATTRIBUTES)

          base.user_attributes&.push :vendor_ids
        end

        @@vendor_attributes = [:id, :name, :slug, :state, :about_us, :contact_us, :priority]
      end
    end
  end
end

Spree::Api::ApiHelpers.prepend(SolidusMultiVendor::Spree::Api::ApiHelpersDecorator)
