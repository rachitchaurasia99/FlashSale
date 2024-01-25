class CreateLineItems < ActiveRecord::Migration[7.0]
  def change
    create_table :line_items do |t|
      t.references :deal, null: false, foreign_key: true
      t.references :order, null: false, foreign_key: true
      t.integer :quantity, default: 0
      t.integer :price_in_cents, default: 0
      t.integer :discount_price_in_cents, default: 0
      t.integer :tax_in_cents, default: 0
      t.integer :total_in_cents, default: 0
      t.integer :total_discount_price_in_cents, default: 0
      t.integer :net_in_cents, default: 0
      t.timestamps
    end
  end
end
