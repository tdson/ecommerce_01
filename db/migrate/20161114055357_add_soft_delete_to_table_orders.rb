class AddSoftDeleteToTableOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :deleted_at, :timestamp, default: nil, null: true
    add_column :order_products, :deleted_at, :timestamp, default: nil, null: true
  end
end
