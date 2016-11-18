class Suggestion < ApplicationRecord
  belongs_to :user

  validates :content, presence: true, length: {maximum: 1024}
  validates :user, presence: true
end
