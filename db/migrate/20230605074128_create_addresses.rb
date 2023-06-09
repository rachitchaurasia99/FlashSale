class CreateAddresses < ActiveRecord::Migration[7.0]
  def change
    create_table :addresses do |t|
      t.string :name
      t.string :email
      t.references :user
      t.references :order
      t.string :city
      t.string :state
      t.string :country
      t.integer :pincode
      t.timestamps
    end
  end
end
