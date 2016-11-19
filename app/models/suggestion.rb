class Suggestion < ApplicationRecord
  belongs_to :user

  validates :content, presence: true, length: {maximum: 512}
  validates :user, presence: true

  scope :order_by_read_and_reccent, -> {order("is_read, created_at")}
  scope :search, ->q do
    where "id = #{q.to_i}
      OR content LIKE '%#{q}%'" if q.present?
  end
end
