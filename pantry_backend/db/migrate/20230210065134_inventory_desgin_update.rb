# Migration to Update Inventory table schema
class InventoryDesginUpdate < ActiveRecord::Migration[5.0]
  def change
    remove_column :inventories, :name
    remove_column :inventories, :description
    remove_column :inventories, :preparation_details
    remove_column :inventories, :rating
    add_reference :inventories, :item, foreign_key: true
  end
end
