class OrderProduct < ApplicationRecord
  belongs_to :order
  belongs_to :product

  after_create :update_product_quantity

  private
  def update_product_quantity
    remaining_qty = self.product.quantity - self.quantity
    self.product.update_attributes quantity: remaining_qty
  end
end
