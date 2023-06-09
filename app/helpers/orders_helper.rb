module OrdersHelper
  def order_total
    current_order.line_items.sum(&:line_item_total)
  end
end
