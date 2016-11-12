class OrderProduct < ApplicationRecord
  belongs_to :order
  belongs_to :product

  after_create :update_product_quantity

  private
  def update_product_quantity
    product = Product.find self.product_id
    remaining_qty = product.quantity - self.quantity
    product.update_attributes quantity: remaining_qty
  end
end
