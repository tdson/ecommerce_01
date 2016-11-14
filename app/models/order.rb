class Order < ApplicationRecord
  @@session_cart = nil

  belongs_to :user
  has_many :order_products, dependent: :destroy
  has_many :products, through: :order_products

  enum status: [:pending, :done, :cancel]

  after_create :build_order_products

  scope :last_7_days_qty, -> do
    joins(:order_products)
      .select("DATE(orders.created_at) AS `date`,
        COUNT(order_products.id) AS `quantity`")
      .where("DATE(orders.created_at) >=
        '#{Settings.statistics_in_seven_days.days.ago}'")
      .group "DATE(orders.created_at)"
  end

  class << self
    def set_session_cart cart
      @@session_cart = cart
    end
  end

  def total_cost
    total = 0
    self.order_products.each do |order_product|
      total += order_product.current_price
    end
    total
  end

  private
  def build_order_products
    @cart = @@session_cart
    @cart.keys.each do |item|
      product = Product.find item.to_i
      qty = @cart[item].to_i
      self.order_products.create product_id: product.id,
        quantity: qty,
        current_price: product.price
    end
  end
end
