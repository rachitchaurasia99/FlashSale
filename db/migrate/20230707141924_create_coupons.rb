class CreateCoupons < ActiveRecord::Migration[7.0]
  def change
    create_table :coupons do |t|
      t.references :user, null: false, foreign_key: true
      t.string :code, null: false
      t.integer :redeem_count, default: 0
      t.datetime :issued_at, null: false

      t.timestamps
    end
  end
end
