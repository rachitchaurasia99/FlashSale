class RenameTransactionIdToPaymentIntentInPayments < ActiveRecord::Migration[7.0]
  def change
    rename_column :payments, :transaction_id, :payment_intent
  end
end
