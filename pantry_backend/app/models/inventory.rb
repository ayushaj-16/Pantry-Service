# Model to store items in Inventory
class Inventory < ApplicationRecord
  validates :stock, numericality: { greater_than: 0 }
end
