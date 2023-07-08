class CouponNotifierJob < ApplicationJob
  def perform
    User.active.each do |user|
      user.coupons.create
      CouponMailer.send_coupon(user).deliver_now
    end
  end
end
