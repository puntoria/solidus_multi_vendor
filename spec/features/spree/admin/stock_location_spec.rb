require 'spec_helper'

RSpec.describe 'Admin Stock Locations', :js do
  let(:active_vendor) { create(:active_vendor) }
  let!(:product) { create(:product, vendor_id: active_vendor.id, name: 'Test') }
  let!(:user) { create(:user, vendors: [active_vendor]) }
  let!(:admin) { create(:admin_user) }
  let!(:stock_location) { create(:stock_location, name: 'Test') }

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

    context 'stock movements' do
      it 'displays stock movements for vendor stock location' do
        click_on 'Stock Movements'
        expect(page).to have_text 'Stock Movements for Active vendor'
      end

      it 'can create a new stock movement for vendor stock location' do
        click_on 'Stock Movements'
        click_on 'New Stock Movement'
        expect(page).to have_current_path spree.new_admin_stock_location_stock_movement_path(active_vendor.stock_locations.first),
          ignore_query: true

        fill_in 'stock_movement_quantity', with: 5
        select2_open label: 'Stock Item'
        select2_search product.name, from: 'Stock Item'
        select2_select product.name, from: 'Stock Item', match: :first

        click_button 'Create'

        expect(page).to have_text 'successfully created!'
        expect(Spree::StockMovement.count).to eq 1
      end
    end

    context 'create' do
      it 'can create a new stock location' do
        click_link 'New Stock Location'
        expect(page).to have_current_path spree.new_admin_stock_location_path, ignore_query: true

        fill_in 'stock_location_name', with: 'Vendor stock location'

        click_button 'Create'

        expect(page).to have_text 'successfully created!'
        expect(page).to have_current_path spree.admin_stock_locations_path, ignore_query: true
        expect(Spree::StockLocation.last.vendor_id).to eq active_vendor.id
      end
    end

    context 'edit' do
      before do
        within_row(1) { click_icon :edit }
        expect(page).to have_current_path spree.edit_admin_stock_location_path(active_vendor.stock_locations.first),
          ignore_query: true
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
