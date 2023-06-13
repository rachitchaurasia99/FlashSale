class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders do |t|
      t.references :user, null: false, foreign_key: true
      t.references :address, foreign_key: true
      t.date :order_date
      t.integer :status
      t.timestamps
    end
  end
end
