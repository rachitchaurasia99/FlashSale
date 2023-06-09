module CurrentOrder
  def current_order
    @order = Order.find_by(user_id: current_user.id, status: 'In Progress') || Order.create(user_id: current_user.id, status: 'In Progress')
  end
end
