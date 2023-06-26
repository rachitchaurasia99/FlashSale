class AddPaymentIntentToPayments < ActiveRecord::Migration[7.0]
  def change
    add_column :payments, :payment_intent, :string
  end
end
