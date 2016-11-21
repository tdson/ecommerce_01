class Order < ApplicationRecord
  @@session_cart = nil

  belongs_to :user
  has_many :order_products, dependent: :destroy
  has_many :products, through: :order_products

  enum status: [:pending, :done, :canceled]

  validates :user, presence: true
  validates :full_name, presence: true, length: {maximum: 128}
  validates :shipping_address, presence: true, length: {maximum: 255}
  validates :phone, presence: true, length: {maximum: 15}

  after_create :build_order_products

  scope :recent, ->{order created_at: :desc}
  scope :quantity_within, ->range do
    left_outer_joins(:order_products)
      .select("DATE(orders.created_at) AS date,
        COUNT(order_products.id) AS quantity")
      .where("DATE(orders.created_at) >=
        '#{Settings.date_range[range].days.ago}'")
      .group("date")
      .order "date"
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
