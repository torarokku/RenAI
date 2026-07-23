class User < ApplicationRecord
  has_secure_password
  has_many :conversations
  has_many :user_badges, dependent: :destroy

  validates :name, presence: true
  validates :password, presence: true
end