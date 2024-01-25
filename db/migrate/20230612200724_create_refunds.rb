class CreateRefunds < ActiveRecord::Migration[7.0]
  def change
    create_table :refunds do |t|
      t.references :order
      t.string :refund_id
      t.string :currency
      t.integer :status, default: 0
      t.integer :total_amount_in_cents, default: 0
      
      t.timestamps
    end
  end
end
