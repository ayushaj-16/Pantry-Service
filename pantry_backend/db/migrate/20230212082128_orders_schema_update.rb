# Migration to update Orders schema
class OrdersSchemaUpdate < ActiveRecord::Migration[5.0]
  def change
    remove_column :orders, :order_id
    remove_column :orders, :item_id
    add_column :orders, :instructions, :string
    add_column :orders, :status, :string
  end
end
