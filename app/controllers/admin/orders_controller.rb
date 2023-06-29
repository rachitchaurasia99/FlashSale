class Admin::OrdersController < Admin::BaseController
  before_action :set_order, only: %i[deliver_order cancel_order]
  
  def index
    if params[:email]
      @orders = User.find_by(email: params[:email]).orders.not_InProgress
      flash[:notice] = 'No orders found' if @orders.empty?
    else
      @orders = Order.includes(:address).not_InProgress
    end
  end

  def deliver_order
    @order.Delivered!
    OrderMailer.with(order: @order).delivered.deliver_later
    redirect_to request.referer
  end

  def cancel_order
    payment_intent = Stripe::PaymentIntent.retrieve(@order.payments.successful.payment_intent)
    refund = Stripe::Refund.create({
      payment_intent: payment_intent
    })
    @order.refunds.create(refund_id: refund.id, status: 'Successful', currency: 'inr', total_amount_in_cents: refund.amount)
    @order.Cancelled!
    OrderMailer.with(order: @order, refund_id: refund.id).cancelled.deliver_later
    redirect_to request.referer
  end

  private 

  def set_order
    @order = Order.find_by(id: params[:id])
    redirect_to request.referer, alert: "Order Not found" unless @order
  end
end
