class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  enum role: { customer: 0, Admin: 1 }

  validates :first_name, presence: true

  def admin?
    role == 'Admin'
  end
end
