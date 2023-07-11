class AddCouponToOrders < ActiveRecord::Migration[7.0]
  def change
    add_column :orders, :coupon, :json, default: {}
  end
end
