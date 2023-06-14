class Order < ApplicationRecord
  include ActiveModel::Serialization

  enum :status, {'In Progress': 0, 'Placed': 1, 'Delivered': 2, 'Cancelled': 3}
  
  belongs_to :user
  belongs_to :address, optional: true
  has_many :payments
  has_many :line_items, dependent: :destroy
  has_many :deals, through: :line_items

  accepts_nested_attributes_for :address, allow_destroy: true

  scope :placed_orders, ->{ includes(:address, :payments).where.not(status: 'In Progress').where(payments: { status: 'Successful' }) }
  scope :users_placed_orders, ->(user_id){ where(user_id: user_id).placed_orders }
  
  def total_tax
    line_items.sum(&:tax_on_deal)
  end

  def order_total
    total = line_items.sum(&:total_price)
    order_count = user.orders.size

    if order_count > 3
      total - 0.05 * total
    elsif order_count > 2
      total - 0.02 * total
    elsif order_count > 1
      total - 0.01 * total
    else
      total
    end
  end
    
  def serialize
    serializable_hash(only: [:id, :deal_id, :address_id, :status])
  end
end
