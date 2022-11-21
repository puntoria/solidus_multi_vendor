class AddPriorityToSpreeVendors < ActiveRecord::Migration[4.2]
  def change
    add_column :spree_vendors, :position, :integer
    Spree::Vendor.order(:updated_at).each.with_index(1) do |vendor, index|
      vendor.update_column :position, index
    end
  end
end
