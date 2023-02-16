# Migration to create orders table
class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :token
      t.datetime :expireAt

      t.timestamps
    end
  end
end
