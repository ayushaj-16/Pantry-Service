# Migration to create Inventory table
class CreateInventories < ActiveRecord::Migration[5.0]
  def change
    create_table :inventories do |t|
      t.string :name
      t.string :description
      t.json :preparation_details
      t.integer :stock
      t.integer :rating, default: 0

      t.timestamps
      # add_column :Inventory, :test_param, :data_type
      # add_index :Inventory, :test_param
      # remove_column :Inventory, :test_param, :data_type
    end
  end
end
