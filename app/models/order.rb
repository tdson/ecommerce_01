class Order < ApplicationRecord
  @@session_cart = nil

  belongs_to :user
  has_many :order_products, dependent: :destroy
  has_many :products, through: :order_products

  accepts_nested_attributes_for :order_products,
    reject_if: proc {|attributes| attributes[:quantity].blank?},
    allow_destroy: true

  enum status: [:pending, :done, :canceled]

  validates :user, presence: true
  validates :full_name, presence: true, length: {maximum: 128}
  validates :shipping_address, presence: true, length: {maximum: 255}
  validates :phone, presence: true, length: {maximum: 15}

  after_create :build_order_products

  default_scope {where deleted_at: nil}
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
  scope :with_status, ->status {where status: status if status.present?}
  scope :sort_by_recently, ->{order created_at: :desc}
  scope :search, ->q do
    where "id = #{q.to_i}
      OR full_name LIKE '%#{q}%'
      OR shipping_address LIKE '%#{q}%'
      OR phone LIKE '%#{q}%'" if q.present?
  end

  class << self
    def set_session_cart cart
      @@session_cart = cart
    end
  end

  def total_cost
    total = 0
    self.order_products.each do |order_product|
      total += order_product.current_price * order_product.quantity
    end
    total
  end

  def destroy
    destroy_order_products if update_attribute :deleted_at, Time.now
  end

  def give_product_back
    self.order_products.each do |order_product|
      order_product.give_back
    end
  end

  def is_pending?
    self.status == Settings.order_status_in_word[:pending]
  end

  def is_accepted?
    self.status == Settings.order_status_in_word[:done]
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

  def destroy_order_products
    self.order_products.each {|item| item.destroy}
  end
end
