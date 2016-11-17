class Order < ApplicationRecord
  @@session_cart = nil

  belongs_to :user
  has_many :order_products, dependent: :destroy
  has_many :products, through: :order_products

  enum status: [:pending, :done, :cancel]

  validates :full_name, presence: true, length: {maximum: 128}
  validates :shipping_address, presence: true, length: {maximum: 255}
  validates :phone, presence: true, length: {maximum: 15}

  after_create :build_order_products

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
    cart = @@session_cart
    cart.keys.each do |item|
      product = Product.find item.to_i
      quantity = cart[item].to_i
      self.order_products.create product_id: product.id,
        quantity: quantity,
        current_price: product.price
    end
  end
end
