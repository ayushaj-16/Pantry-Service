# Model to store details of Items
class Item < ApplicationRecord
  validates :name, presence: true, length: { minimum: 2, maximum: 20 }
  validates :preparation_details, presence: true
end
