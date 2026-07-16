class UserEvent < ApplicationRecord
  belongs_to :user
  belongs_to :partner

  validates :event_key, presence: true
end
