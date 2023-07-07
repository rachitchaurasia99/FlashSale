class CreateCurrency < ActiveRecord::Migration[7.0]
  def change
    create_table :currencies do |t|
      t.string :name
      t.decimal :conversion_rate
      t.date :date

      t.timestamps
    end
  end
end
