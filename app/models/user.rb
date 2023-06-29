class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  enum role: { customer: 0, admin: 1 }

  has_many :orders
  has_many :payments, through: :orders
  has_many :addresses, dependent: :destroy
  has_secure_token :auth_token

  validates :first_name, presence: true

  after_create :generate_auth_token
  
  scope :customers_orders, ->(from, to){ includes(:orders).includes(:payments).where('DATE(order_at) BETWEEN ? AND ?', from, to).where(orders: { status: 'delivered' }).where(payments: { status: 'successful' }) }
  scope :orders_by_email, ->{ includes(:orders).where(status: 'delivered')}
  
  def self.top_spending_customers(from, to)
    customers_order_amount = {}
    customers_orders(from, to).map { |customer| customers_order_amount.store(customer, customer.payments.sum(&:total_amount)) }
    customers_order_amount.sort_by { |customer, amount| -amount }
  end

  def generate_auth_token
    regenerate_auth_token
  end
end
