# Migration to change Inventory schema
class InventoryChangeColumnType < ActiveRecord::Migration[5.0]
  def change
    change_column :inventories, :preparation_details, :jsonb
    drop_column :inventories, :name
    drop_column :inventories, :description
    drop_column :inventories, :preparation_details
    drop_column :inventories, :rating
  end
end
