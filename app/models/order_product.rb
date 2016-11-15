class OrderProduct < ApplicationRecord
  belongs_to :order
  belongs_to :product

  validates :quantity, presence: true
  validates :order, presence: true
  validates :product, presence: true
  validate :valid_quantity

  after_create :update_product_quantity

  default_scope {where deleted_at: nil}

  def destroy
    update_attribute :deleted_at, Time.now
  end

  def give_back
    product = Product.find self.product.id
    product.quantity += self.quantity
    product.save
  end

  private
  def update_product_quantity
    product = Product.find self.product_id
    remaining_qty = product.quantity - self.quantity
    product.update_attributes quantity: remaining_qty
  end

  def valid_quantity
    if self.product.quantity < self.quantity ||
      self.quantity < Settings.minimum_qty
      errors.add :quantity, I18n.t("validation.product.not_enough",
        qty: self.product.quantity)
    end
  end
end
