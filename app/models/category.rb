class Category < ApplicationRecord
  acts_as_nested_set
  has_many :products, dependent: :destroy

  scope :depth_flow, ->{order :depth}
  scope :main_category, ->{where depth: 0}
end
