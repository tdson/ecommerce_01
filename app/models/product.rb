class Product < ApplicationRecord
  belongs_to :category
  has_many :order_products, dependent: :destroy
  has_many :orders, through: :order_products
  has_many :ratings, dependent: :destroy
  delegate :name, to: :category, prefix: :category

  mount_uploader :image, ProductImageUploader

  scope :recent, ->{order created_at: :DESC}

  def sold_out?
    self.quantity <= Settings.sold_out
  end
end
