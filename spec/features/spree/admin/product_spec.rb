require 'spec_helper'

RSpec.describe 'Admin Products', :js do
  let(:vendor) { create(:vendor) }
  let!(:user) { create(:user, vendors: [vendor]) }
  let!(:admin) { create(:admin_user) }
  let!(:option_type) { create(:option_type, name: 'Testing option') }
  let!(:option_value) { create(:option_value, option_type: option_type) }
  let!(:product) { create(:product, sku: 'Test1') }
  let!(:vendor_product) { create(:product, vendor: vendor, sku: 'Test2', option_types: [option_type]) }

  context 'for user with admin role' do
    before { login_as(admin, scope: :spree_user) }

    context 'index' do
      it 'displays all products' do
        visit spree.admin_products_path
        expect(page).to have_selector('tr', count: 3)
      end
    end
  end

  context 'for user with vendor' do
    before do
      login_as(user, scope: :spree_user)
      visit spree.admin_products_path
    end

    context 'index' do
      it 'displays only vendor product' do
        expect(page).to have_selector('tr', count: 2)
      end

      it 'does not display product types' do
        expect(page).not_to have_text 'Property Types'
      end
    end

    context 'create' do
      it 'can create a new product' do
        click_link 'New Product'
        fill_in 'product_name', with: 'Vendor product'
        fill_in 'product_price', with: 15
        select Spree::ShippingCategory.last.name

        click_button 'Create'

        expect(page).to have_text 'successfully created!'
        expect(Spree::Product.last.vendor_id).to eq vendor.id
      end
    end

    context 'edit product' do
      before do
        within_row(1) { click_icon :edit }
      end

      it 'can update an existing product' do
        fill_in 'product_name', with: 'Testing edit'
        click_button 'Update'
        expect(page).to have_text 'successfully updated!'
        expect(page).to have_text 'Testing edit'
      end

      it 'can update product master price' do
        fill_in 'product_price', with: 123
        click_button 'Update'
        expect(page).to have_text 'successfully updated!'
        vendor_product.reload
        expect(vendor_product.price).to eq 123
      end

      it 'shows validation error with blank name' do
        fill_in 'product_name', with: ''
        click_button 'Update'

        expect(page).to have_current_path(spree.edit_admin_product_path(vendor_product))
      end
    end

    context 'create product property' do
      it 'cannot create new product property' do
        visit spree.admin_product_product_properties_path(vendor_product)
        fill_in 'product[product_properties_attributes][0][property_name]', with: 'Testing edit'
        click_button 'Update'
        expect(page).to have_text 'successfully updated!'
      end
    end
  end
end
