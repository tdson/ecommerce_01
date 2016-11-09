class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable, :rememberable,
    :trackable, :confirmable, :omniauthable,
    omniauth_providers: [:facebook, :google_oauth2, :twitter]

  has_many :orders, dependent: :destroy
  has_many :suggestions, dependent: :destroy
  has_many :ratings, dependent: :destroy

  enum roles: [:admin, :mod, :member]
end
