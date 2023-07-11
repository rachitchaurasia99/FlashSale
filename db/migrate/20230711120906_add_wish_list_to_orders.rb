class AddWishListToOrders < ActiveRecord::Migration[7.0]
  def change
    add_column :orders, :wishlist, :boolean, default: false
  end
end
