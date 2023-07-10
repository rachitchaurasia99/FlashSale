class Coupon < ApplicationRecord
  belongs_to :user

  has_secure_token :code

  before_validation :generate_code

  def generate_code
    self.issued_at = DateTime.current.beginning_of_day
    self.code = SecureRandom.hex(4)
  end

  def is_valid?
    issued_at.to_date == Date.current && redeem_count < MAXIMUM_COUPON_ATTEMPTS
  end
end
