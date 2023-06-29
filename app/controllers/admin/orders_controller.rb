class Admin::OrdersController < Admin::BaseController
  before_action :set_order, only: %i[deliver_order cancel_order]
  
  def index
    if params[:email]
      @orders = User.find_by(email: params[:email]).orders.not_InProgress
      flash[:notice] = 'No orders found' if @orders.empty?
    else
      @orders = Order.not_in_progress
    end
  end

  def deliver_order
    @order.delivered!
    OrderMailer.with(order: @order).delivered.deliver_later
    redirect_to request.referer
  end

  def cancel_order
    refund = StripeRefundHandler.new(@order).create_refund
    @order.refunds.create(refund_id: refund.id, status: 'successful', currency: 'inr', total_amount_in_cents: refund.amount)
    @order.cancelled!
    OrderMailer.with(order: @order, refund_id: refund.id).cancelled.deliver_later
    redirect_to request.referer
  end

  private 

  def set_order
    @order = Order.find_by(id: params[:id])
    redirect_to request.referer, alert: "Order Not found" unless @order
  end
end
