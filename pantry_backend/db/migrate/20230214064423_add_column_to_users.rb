# Migration to add employee_id column in User table
class AddColumnToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :employee_id, :integer
    add_index :users, :employee_id, unique: true
  end
end
