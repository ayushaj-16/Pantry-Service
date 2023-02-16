# Migration to update status column from string to enum
class ChangeColumnToOrders < ActiveRecord::Migration[5.0]
  def change
    change_column :orders, :status, 'integer USING CAST(status AS integer)'
    # Ex:- change_column("admin_users", "email", :string, :limit =>25)
  end
end
