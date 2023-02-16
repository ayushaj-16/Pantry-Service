# Migration to create Orders table
class CreateOrders < ActiveRecord::Migration[5.0]
  def change
    create_table :orders do |t|
      t.integer :order_id
      t.integer :employee_id
      t.references :item, foreign_key: true
      t.integer :quantity

      t.timestamps
    end
  end
end
