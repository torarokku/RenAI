class User < ApplicationRecord
  has_secure_password

  has_many :conversations, dependent: :destroy
  has_many :user_partners, dependent: :destroy
  has_many :partners, through: :user_partners
end