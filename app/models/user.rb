class User < ApplicationRecord
  has_many :tasks
  validates :email, presence: true
  has_secure_password
end
