# frozen_string_literal: true

module SolidusMultiVendor
  module Spree
    module Admin
      module UsersControllerDecorator
        private

        def user_params
          params.require(:user).permit(permitted_user_attributes |
                                       [spree_role_ids: [],
                                        vendor_ids: [],
                                        ship_address_attributes: permitted_address_attributes,
                                        bill_address_attributes: permitted_address_attributes])
        end
      end
    end
  end
end

Spree::Admin::UsersController.prepend SolidusMultiVendor::Spree::Admin::UsersControllerDecorator
