require 'spec_helper'

RSpec.describe 'Admin Vendors', :js do
  let!(:admin) { create(:admin_user) }

  before do
    login_as(admin, scope: :spree_user)
    create(:vendor, name: 'My vendor')
    visit spree.admin_vendors_path
  end

  context 'index' do
    it 'displays existing vendors' do
      within("table.table tbody tr:nth-of-type(1)") do
        expect(column_text(1)).to eq 'My vendor'
        expect(column_text(2)).to eq 'pending'
      end
    end
  end

  context 'create' do
    it 'can create a new vendor' do
      click_link 'New Vendor'
      expect(page).to have_current_path(spree.new_admin_vendor_path)

      fill_in 'vendor_name', with: 'Test'
      select2_search 'Blocked', from: 'state'

      click_button 'Create'

      expect(page).to have_text 'successfully created!'
      expect(page).to have_current_path(spree.admin_vendors_path)
    end

    it 'shows validation error with blank name' do
      click_link 'New Vendor'
      expect(page).to have_current_path(spree.new_admin_vendor_path)

      fill_in 'vendor_name', with: ''
      click_button 'Create'

      expect(page).to have_text 'Name can\'t be blank'
    end

    it 'shows validation error with repeated name' do
      click_link 'New Vendor'
      expect(page).to have_current_path(spree.new_admin_vendor_path)

      fill_in 'vendor_name', with: 'My vendor'
      click_button 'Create'

      expect(page).to have_text 'Name has already been taken'
    end
  end

  context 'edit' do
    before do
      within("table.table tbody tr:nth-of-type(1)") { click_icon :edit }
      expect(page).to have_current_path(spree.edit_admin_vendor_path(1))
    end

    it 'can update an existing vendor' do
      fill_in 'vendor_name', with: 'Testing edit'
      click_button 'Update'
      expect(page).to have_text 'successfully updated!'
      expect(page).to have_text 'Testing edit'
    end

    it 'shows validation error with blank name' do
      fill_in 'vendor_name', with: ''
      click_button 'Update'
      expect(page).to have_text 'Name can\'t be blank'
    end

    it 'shows validation error with repeated name' do
      create(:vendor, name: 'New vendor')

      fill_in 'vendor_name', with: 'New vendor'
      click_button 'Update'
      expect(page).to have_text 'Name has already been taken'
    end
  end
end
