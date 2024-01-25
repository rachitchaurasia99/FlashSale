class CreatePayments < ActiveRecord::Migration[7.0]
  def change
    create_table :payments do |t|
      t.references :order, null: false, foreign_key: true
      t.string :session_id
      t.string :payment_intent
      t.string :currency
      t.integer :status, default: 0
      t.integer :total_amount_in_cents, default: 0
      
      t.timestamps
    end
  end
end
