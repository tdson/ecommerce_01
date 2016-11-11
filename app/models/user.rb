class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable, :rememberable,
    :trackable, :confirmable, :omniauthable,
    omniauth_providers: [:facebook, :google_oauth2, :twitter]

  mount_uploader :avatar, ImageUploader

  has_many :orders, dependent: :destroy
  has_many :suggestions, dependent: :destroy
  has_many :ratings, dependent: :destroy
  has_one :order

  enum roles: [:admin, :mod, :member]

  validates :name, presence: true, length: {minimum: 2, maximum: 128}
  validates :email, presence: true, if: ->{self.provider.blank?}
  validates :password, length: {minimum: 6}, presence: true, allow_nil: true
  validates :address, length: {maximum: 255}
  validates :phone_number, length: {maximum: 15}
  validates :chatwork_id, length: {maximum: 128}

  class << self
    def from_omniauth auth
      where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
        user.email = auth.info.email if auth.info.email
        user.name = auth.info.name
        user.password = Devise.friendly_token[0, 20]
        user.provider = auth.provider
        user.uid = auth.uid
        user.confirmation_token = SecureRandom.urlsafe_base64
        user.confirmed_at = Time.now
      end
    end
  end
end
