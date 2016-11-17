class Rating < ApplicationRecord
  belongs_to :product
  belongs_to :user

  scope :average_of, ->product do
    select("product_id,
      ROUND(AVG(rating), #{Settings.round_to_hundredth}) as value,
      COUNT(id) as count")
      .find_by product_id: product.id
  end
end
