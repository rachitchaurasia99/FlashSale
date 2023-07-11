module OrderHelper
  def current_order
    current_orders = current_user.orders.in_progress
    @order = current_orders.last || current_orders.create
  end

  def user_wishlist
    user_orders = current_user.orders
    @wishlist = user_orders.where(wishlist: true).first || user_orders.create(wishlist: true)
  end
end
