class AddColumnsToTableOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :full_name, :string
    add_column :orders, :shipping_address, :string
    add_column :orders, :phone, :string

    change_column :order, :status, :integer, default: 0
  end
end
