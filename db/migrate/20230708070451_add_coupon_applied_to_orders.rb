class AddCouponAppliedToOrders < ActiveRecord::Migration[7.0]
  def change
    add_column :orders, :coupon_applied, :boolean, default: false
  end
end
