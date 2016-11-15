class Product < ApplicationRecord
  belongs_to :category
  has_many :order_products, dependent: :destroy
  has_many :orders, through: :order_products
  has_many :ratings, dependent: :destroy

  scope :with_average_rating, ->product_id do
    left_joins(:ratings).where("`products`.`id` = #{product_id}")
      .select("`products`.*,
        round(sum(`ratings`.`rating`)/count(`ratings`.`id`), 0) as `rating`")
      .group "`products`.`id`"
  end

  scope :top_product, ->limit do
    joins(:order_products)
      .select("products.name, COUNT(order_products.product_id) AS quantity")
      .where("order_products.created_at >=
        '#{Settings.statistics_in_seven_days.days.ago}'")
      .group("products.name")
      .order("quantity desc")
      .limit limit
  end

  def image_path
    self.image? ? self.image : Settings.product_default
  end

  def sold_out?
    self.quantity < Settings.minimum_qty
  end

  def update_quantity amount
    self.quantity += amount
    self.save
  end
end
