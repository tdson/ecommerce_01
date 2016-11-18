class Category < ApplicationRecord
  include TheSortableTree::Scopes
  acts_as_nested_set
  has_many :products, dependent: :destroy

  validates :name, presence: true

  scope :depth_flow, ->{order :depth}
  scope :main_category, ->{where depth: 0}
  scope :recent, ->{order created_at: :DESC}
  scope :alphabet, ->{order :name}
end
