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
      .select("products.name, COUNT(order_products.product_id) AS quantity")
      .where("order_products.created_at >=
        '#{Settings.date_range[range].days.ago}'")
      .group("products.name")
      .order("quantity desc")
      .limit limit
  end
  scope :top_new, ->limit do
    order(created_at: :desc)
      .limit limit
  end
  scope :hot_trend, ->date_range, limit do
    select("products.id, products.name, products.price, products.image")
      .joins(:order_products)
      .where("order_products.created_at >= '#{date_range.month.ago}'")
      .group("products.id")
      .order("COUNT(order_products.id) DESC")
      .limit limit
  end
  scope :search, ->q {where "products.name LIKE '%#{q}%'" if q.present?}

  def sold_out?
    self.quantity < Settings.minimum_quantity
  end

  def update_quantity amount
    self.quantity += amount
    self.save
  end
end
