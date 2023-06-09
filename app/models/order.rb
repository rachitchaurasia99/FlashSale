class Order < ApplicationRecord
  enum :status, {'In Progress': 0, 'Placed': 1, 'Delivered': 2, 'Cancelled': 1}
  
  belongs_to :user
  has_one :payment
  has_many :line_items, dependent: :destroy
  has_many :deals, through: :line_items

  has_one :address
  accepts_nested_attributes_for :address, allow_destroy: true

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
end
