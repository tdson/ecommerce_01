class Product < ApplicationRecord
  belongs_to :category
  has_many :order_products, dependent: :destroy
  has_many :orders, through: :order_products
  has_many :ratings, dependent: :destroy

  validates :price, numericality: true, allow_nil: true
  validates :quantity, numericality: true, allow_nil: true
  validates :name, presence: true

  scope :recent, ->{order created_at: :DESC}
  scope :alphabet, ->{order :name}
  mount_uploader :image, ProductImageUploader
end
