class Product < ApplicationRecord
  belongs_to :category
  has_many :order_products, dependent: :destroy
  has_many :orders, through: :order_products
  has_many :ratings, dependent: :destroy

  scope :recent, ->{order created_at: :DESC}
  mount_uploader :image, ProductImageUploader
end
