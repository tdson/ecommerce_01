class Product < ApplicationRecord
  belongs_to :category
  has_many :order_products, dependent: :destroy
  has_many :orders, through: :order_products
  has_many :ratings, dependent: :destroy
  delegate :name, to: :category, prefix: :category

  mount_uploader :image, ProductImageUploader

  scope :recent, ->{order created_at: :DESC}
  scope :top_product_within, ->(range, limit) do
    joins(:order_products)
      .select("products.name, SUM(order_products.quantity) AS quantity")
      .where("order_products.created_at >=
        '#{Settings.date_range[range].days.ago}'")
      .group("products.name")
      .order("quantity desc")
      .limit limit
  end

  def sold_out?
    self.quantity < Settings.minimum_quantity
  end
end
