class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  enum role: { customer: 0, admin: 1 }

  has_many :orders
  has_many :addresses, dependent: :destroy
  has_secure_token :auth_token

  validates :first_name, presence: true
end
