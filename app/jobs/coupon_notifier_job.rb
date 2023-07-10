class CouponNotifierJob < ApplicationJob
  def perform
    User.active.each do |user|
      coupon = user.coupons.create
      CouponMailer.send_coupon(user, coupon).deliver_now
    end
  end
end
