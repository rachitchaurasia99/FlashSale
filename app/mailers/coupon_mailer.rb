class CouponMailer < ApplicationMailer
  default from: 'FlashDeals'

  def send_coupon(user)
    @user = user
    mail to: user.email, subject: 'FlashDeal Daily Coupon'
  end
end
