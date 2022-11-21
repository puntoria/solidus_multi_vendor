require 'spec_helper'

RSpec.describe 'Admin Vendors', :js do
  let!(:admin) { create(:admin_user) }
  let!(:vendor_user) { create(:user) }

  before do
    login_as(admin, scope: :spree_user)
    create(:active_vendor, users: [vendor_user]) if Spree::Vendor.find_by(name: 'Active vendor').nil?
    create(:pending_vendor)
    create(:blocked_vendor)
    visit spree.admin_vendors_path
  end

  context 'index' do
    it 'displays existing vendors' do
      within_row(1) do
        expect(column_text(1)).to eq vendor_user.email
        expect(column_text(2)).to eq 'Active vendor'
        expect(column_text(3)).to eq 'active'
      end
    end

    it 'filter by multiple states' do
      click_button 'Filter'
      select2 'Active', from: 'State'
      select2 'Pending', from: 'State'

      click_button 'Filter Results'

      expect(page).to have_content('active')
      expect(page).to have_content('pending')
      expect(page).not_to have_content('blocked')
    end
  end

  context 'create' do
    it 'can create a new vendor' do
      click_link 'New Vendor'
      expect(page).to have_current_path spree.new_admin_vendor_path, ignore_query: true

      fill_in 'vendor_name', with: 'Test'
      fill_in 'vendor_about_us', with: 'About...'
      fill_in 'vendor_contact_us', with: 'Contact...'
      expect(find_field('vendor_commission_rate').value).to eq '5.0'
      select 'Blocked'

      click_button 'Create'

      expect(page).to have_text 'successfully created!'
      expect(page).to have_current_path spree.admin_vendors_path, ignore_query: true
    end

    it 'shows validation error with blank name' do
      click_link 'New Vendor'
      expect(page).to have_current_path spree.new_admin_vendor_path, ignore_query: true

      fill_in 'vendor_name', with: ''
      click_button 'Create'

      expect(page).to have_text 'name can\'t be blank'
    end

    it 'shows validation error with repeated name' do
      click_link 'New Vendor'
      expect(page).to have_current_path spree.new_admin_vendor_path, ignore_query: true

      fill_in 'vendor_name', with: 'Active vendor'
      click_button 'Create'

      expect(page).to have_text 'name has already been taken'
    end
  end

  context 'edit' do
    before do
      within_row(1) { click_icon :edit }
      expect(page).to have_current_path spree.edit_admin_vendor_path('active-vendor'), ignore_query: true
    end

    it 'can update an existing vendor' do
      fill_in 'vendor_name', with: 'Testing edit'
      fill_in 'vendor_about_us', with: 'Testing about us'
      fill_in 'vendor_contact_us', with: 'Testing contact us'
      fill_in 'vendor_commission_rate', with: '5.5'
      click_button 'Update'
      expect(page).to have_text 'successfully updated!'
      expect(page).to have_text 'Testing edit'
    end

    if Spree.version.to_f >= 3.6
      it 'can update an existing vendor image' do
        page.attach_file("vendor_image", "#{Spree::Core::Engine.root}spec/fixturesthinking-cat.jpg")
        expect { click_button 'Update' }.to change(Spree::VendorImage, :count).by(1)
        expect(page).to have_text 'successfully updated!'
      end
    end

    it 'shows validation error with blank name' do
      fill_in 'vendor_name', with: ''
      click_button 'Update'
      expect(page).to have_text 'name can\'t be blank'
    end

    it 'does not show validation error with blank about_us' do
      fill_in 'vendor_about_us', with: ''
      click_button 'Update'
      expect(page).not_to have_text 'about_us can\'t be blank'
    end

    it 'does not show validation error with blank contact_us' do
      fill_in 'vendor_contact_us', with: ''
      click_button 'Update'
      expect(page).not_to have_text 'contact_us can\'t be blank'
    end

    it 'shows validation error with repeated name' do
      create(:vendor, name: 'New vendor')

      fill_in 'vendor_name', with: 'New vendor'
      click_button 'Update'
      expect(page).to have_text 'name has already been taken'
    end
  end
end
