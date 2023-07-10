class Coupon < ApplicationRecord
  belongs_to :user

  has_secure_token :code

  before_validation :set_issued_at
  after_create :generate_code
  
  def set_issued_at
    self.issued_at = DateTime.current.beginning_of_day
  end

  def generate_code
    regenerate_code
  end

  def is_valid?(applied_code)
    issued_at.to_date == Date.current && redeem_count.to_i <= MAXIMUM_COUPON_ATTEMPTS && applied_code == code
  end
end
