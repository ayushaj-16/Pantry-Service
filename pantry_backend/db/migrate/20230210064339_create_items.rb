# Migration to create Items table
class CreateItems < ActiveRecord::Migration[5.0]
  def change
    create_table :items do |t|
      t.string :name
      t.string :description
      t.jsonb :preparation_details
      t.integer :rating
      t.integer :reviewers

      t.timestamps
    end
  end
end
