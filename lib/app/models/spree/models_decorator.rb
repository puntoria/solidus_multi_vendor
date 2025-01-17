# frozen_string_literal: true

module Spree
  module ModelsDecorator
    SpreeMultiVendor.vendorized_models.each do |model|
      model.include Spree::VendorConcern
    end
  end
end
