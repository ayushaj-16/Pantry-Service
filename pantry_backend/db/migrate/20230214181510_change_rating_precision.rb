# Migration to set the precision of rating
class ChangeRatingPrecision < ActiveRecord::Migration[5.0]
  def change
    change_column :items, :rating, :decimal, precision: 2, scale: 1
  end
end
