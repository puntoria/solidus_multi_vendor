# frozen_string_literal: true

module SolidusMultiVendor
  module Spree
    module Api
      module V1
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
end

Spree::Api::UsersController.prepend SolidusMultiVendor::Spree::Api::V1::UsersControllerDecorator
