class CreateCoupons < ActiveRecord::Migration[7.0]
  def change
    create_table :coupons do |t|
      t.string :coupon_type
      t.string :currency
      t.integer :value, default: 0
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
