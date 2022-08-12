# frozen_string_literal: true

module Spree
  module PermittedAttributes
    ATTRIBUTES << :vendor_attributes

    mattr_reader(*ATTRIBUTES)

    @@vendor_attributes = [:name]
  end
end
