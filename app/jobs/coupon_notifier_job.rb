class CouponNotifierJob < ApplicationJob
  def perform
    Coupon.active.each do |coupon|
      User.active.each do |user|
        CouponMailer.send_coupon(user, "#{coupon.coupon_type} #{coupon.value}").deliver_now
      end
    end
  end
end
