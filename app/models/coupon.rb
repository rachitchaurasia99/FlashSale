class Coupon < ApplicationRecord
  enum :status, { inactive: 0, active: 1}

  validates :coupon_type, :value, :currency, presence: true
  validates :coupon_type, inclusion: { in: ['flat', 'percent'] }
  validates :value, numericality: { greater_than: 0 }
  validates :currency, inclusion: { in: CURRENCIES }

  def value_in_cents
    value * 100
  end
end
