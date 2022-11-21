# frozen_string_literal: true

module Spree
  class Vendor < Spree::Base
    extend FriendlyId

    acts_as_paranoid
    acts_as_list column: :position
    friendly_id :name, use: %i[slugged history]

    validates :name,
      presence: true,
      uniqueness: { case_sensitive: false }

    validates :slug, uniqueness: true
    validates_associated :image

    validates :notification_email, format: { with: URI::MailTo::EMAIL_REGEXP }, allow_blank: true

    with_options dependent: :destroy do
      has_one :image, as: :viewable, dependent: :destroy, class_name: 'Spree::VendorImage'
      has_many :commissions, class_name: 'Spree::OrderCommission'
      has_many :vendor_users

      SolidusMultiVendor::Config[:vendorized_models].uniq.compact.each do |model|
        has_many model.pluralize.to_sym
      end
    end

    has_many :users, through: :vendor_users, class_name: Spree.user_class.to_s

    after_create :create_stock_location
    after_update :update_stock_location_names

    state_machine :state, initial: :pending do
      event :activate do
        transition to: :active
      end

      event :block do
        transition to: :blocked
      end
    end

    scope :active, -> { where(state: 'active') }

    self.whitelisted_ransackable_attributes = %w[name state]

    def update_notification_email(email)
      update(notification_email: email)
    end

    # Spree Globalize support
    # https://github.com/spree-contrib/spree_multi_vendor/issues/104
    if defined?(SpreeGlobalize)
      attr_accessor :translations_attributes

      translates :name,
        :about_us,
        :contact_us,
        :slug, fallbacks_for_empty_translations: true
    end

    private

    def create_stock_location
      stock_locations.where(name: name, country: Spree::Country.find_by(name: 'Germany')).first_or_create!
    end

    def should_generate_new_friendly_id?
      slug.blank? || name_changed?
    end

    def update_stock_location_names
      if name_changed? || saved_changes&.include?(:name)
        stock_locations.update_all({ name: name })
      end
    end
  end
end
