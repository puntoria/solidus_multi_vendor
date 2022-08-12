# frozen_string_literal: true

module Spree
  module PropertyDecorator
    Spree::Property.whitelisted_ransackable_associations = %w[vendor]
  end
end

Spree::Property.prepend Spree::PropertyDecorator
