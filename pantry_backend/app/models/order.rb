# Model to store orders
class Order < ApplicationRecord
  has_many :order_items

  enum status: { active: 1, delivered: 2, cancelled: 0 }
  validates :employee_id, presence: true
  validates :instructions, presence: true
end
