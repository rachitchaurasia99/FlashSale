class Coupon < ApplicationRecord
  belongs_to :user

  before_save :generate_code

  def generate_code
    self.code = SecureRandom.hex(4)
    self.issued_at = DateTime.current.beginning_of_day
  end

  def is_valid?(applied_code)
    issued_at.to_date == Date.current && redeem_count.to_i <= MAXIMUM_COUPON_ATTEMPTS && applied_code == code
  end
end
