module Cart
  def current_order
    @order = current_user.orders.InProgress.last || Order.create(user_id: current_user.id).InProgress!
  end
end
