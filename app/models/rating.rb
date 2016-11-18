class Rating < ApplicationRecord
  belongs_to :product
  belongs_to :user

  scope :average_of, ->product_id do
    select("product_id,
      ROUND(AVG(rating), #{Settings.round_to_hundredth}) as value_rating,
      COUNT(id) as count_rating")
      .find_by product_id: product_id
  end
end
