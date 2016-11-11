class Category < ApplicationRecord
  has_many :products, dependent: :destroy

  scope :main_category, ->{ where depth="0" }
end
