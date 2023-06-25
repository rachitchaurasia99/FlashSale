class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  enum role: { customer: 0, admin: 1 }

  has_many :orders
  has_many :payments, through: :orders
  has_many :addresses, dependent: :destroy
  has_secure_token :auth_token

  validates :first_name, presence: true

  scope :customers_orders, ->(from, to){ includes(:orders).includes(:payments).where('DATE(order_at) BETWEEN ? AND ?', from, to).where(orders: { status: 'Delivered' }).where(payments: { status: 'Successful' }) }
  scope :orders_by_email, ->{ includes(:orders).where(status: 'Delivered')}
  
  def self.top_spending_customers(from, to)
    customers_order_amount = {}
    customers_orders(from, to).map { |customer| customers_order_amount.store(customer, customer.payments.sum(&:total_amount)) }
    customers_order_amount.sort_by { |customer, amount| -amount }
  end
end
