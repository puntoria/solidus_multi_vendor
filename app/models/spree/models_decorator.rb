# frozen_string_literal: true

module Spree
  module ModelsDecorator
    SolidusMultiVendor.vendorized_models.each do |model|
      model.include Spree::VendorConcern
    end
  end
end
