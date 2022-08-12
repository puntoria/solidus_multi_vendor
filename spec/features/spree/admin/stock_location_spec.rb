require 'spec_helper'

RSpec.describe 'Admin Stock Locations', :js do
  let(:vendor) { create(:vendor) }
  let!(:product) { create(:product, vendor_id: vendor.id, name: 'Test') }
  let!(:user) { create(:user, vendors: [vendor]) }
  let!(:admin) { create(:admin_user) }
  let!(:stock_location) { create(:stock_location, name: 'Test', vendor: vendor) }

  context 'for user with admin role' do
    context 'index' do
      it 'displays all stock locations' do
        login_as(admin, scope: :spree_user)
        visit spree.admin_stock_locations_path
        expect(page).to have_selector('tr', count: 3)
      end
    end
  end

  context 'for user with vendor' do
    before do
      login_as(user, scope: :spree_user)
      visit spree.admin_stock_locations_path
    end

    context 'index' do
      it 'displays only vendor stock location' do
        expect(page).to have_selector('tr', count: 2)
      end
    end

    context 'create' do
      it 'can create a new stock location' do
        click_link 'New Stock Location'

        expect(page).to have_current_path(spree.new_admin_stock_location_path)

        fill_in 'stock_location_name', with: 'Vendor stock location'

        click_button 'Create'

        expect(page).to have_text 'successfully created!'
        expect(Spree::StockLocation.last.vendor_id).to eq vendor.id
      end
    end

    context 'edit' do
      before do
        within_row(1) { click_icon :edit }
        expect(page).to have_current_path(spree.edit_admin_stock_location_path(vendor.stock_locations.first))
      end

      it 'can update an existing stock location' do
        fill_in 'stock_location_name', with: 'Testing edit'
        click_button 'Update'
        expect(page).to have_text 'successfully updated!'
        expect(page).to have_text 'Testing edit'
      end

      it 'shows validation error with blank name' do
        fill_in 'stock_location_name', with: ''
        click_button 'Update'
        expect(page).not_to have_text 'successfully created!'
      end
    end
  end
end
