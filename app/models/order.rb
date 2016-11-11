class Order < ApplicationRecord
  belongs_to :user
  has_one :order_product
  has_many :order_products, dependent: :destroy
  has_many :products, through: :order_products

  enum status: [:pending, :done, :cancel]
end
