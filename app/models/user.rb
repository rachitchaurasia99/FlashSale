class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  enum role: { customer: 0, Admin: 1 }

  has_many :orders
  has_many :payments, through: :orders
  has_many :addresses, dependent: :destroy
  has_secure_token :auth_token

  validates :first_name, presence: true

  scope :customers_orders, ->(from, to){ includes(:orders).includes(:payments).where(orders: { order_date: from..to }).where(orders: { status: 'Delivered' }).where(payments: { status: 'Successful' }) }

  def self.top_spending_customers(from, to)
    customers_order_amount = {}
    customers_orders(from, to).map { |customer| customers_order_amount.store(customer, customer.payments.sum(:total_amount_in_cents)) }
    customers_order_amount.sort_by { |customer, amount| -amount }
  end

  def soft_delete
    update(deactivated_at: Time.current)
  end
  
  def active_for_authentication?
    super && deactivated_at.nil?
  end
end
