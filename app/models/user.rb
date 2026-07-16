class User < ApplicationRecord
  has_secure_password
  has_many :conversations

  validates :name, presence: true
  validates :password, presence: true
end