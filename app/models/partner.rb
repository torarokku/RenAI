class Partner < ApplicationRecord
  has_many :conversations, dependent: :destroy
  has_many :user_partners, dependent: :destroy
  has_many :users, through: :user_partners
  has_many :user_badges, dependent: :destroy
end