# frozen_string_literal: true

vendor = Spree::Vendor.first_or_initialize do |v|
  v.name = 'Test Vendor'
end
vendor.save!

Rails.logger.debug "Created Vendor with the name \"#{vendor.name}\"!"

user = Spree.user_class.where(email: 'user@vendor.com').first_or_initialize do |u|
  u.password = u.password_confirmation = 'vendor123'
end

vendor.users << user unless vendor.users.include?(user)
Rails.logger.debug "Created Vendor Admin User with an email \"#{user.email}\" and password \"#{user.password}\"!"
