class CreateDeals < ActiveRecord::Migration[7.0]
  def change
    create_table :deals do |t|
      t.string :title
      t.string :description
      t.integer :price
      t.integer :cents
      t.integer :discount_cents
      t.integer :quantity, default: 0
      t.date :publish_date
      t.date :published_date
      t.boolean :publishable, default: false
      t.decimal :deals_tax, precision: 8, scale: 2

      t.timestamps
    end
  end
end
