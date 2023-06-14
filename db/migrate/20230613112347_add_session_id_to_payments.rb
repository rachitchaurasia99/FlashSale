class AddSessionIdToPayments < ActiveRecord::Migration[7.0]
  def change
    add_column :payments, :session_id, :string
  end
end
