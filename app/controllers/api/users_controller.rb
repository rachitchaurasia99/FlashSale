class Api::UsersController < Api::BaseController
  skip_forgery_protection
  before_action :set_user, only: %i[my_orders cancel_order]
  
  def my_orders 
    render json: @user.orders.map(&:serialize)
  end

  def cancel_order
    user_order = @user.orders.find_by(id: params[:id])
    if user_order.deals.any? { |deal| deal.expiring_soon? }
      render json: { error: "Order can't be cancelled 30 minutes before the deal ends" }.to_json
    else
      payment_intent = Stripe::PaymentIntent.retrieve(user_order.payments.successful.payment_intent)
      refund = Stripe::Refund.create({
        payment_intent: payment_intent
      })
      user_order.refunds.create(refund_id: refund.id, status: 'Successful', currency: 'inr', total_amount_in_cents: refund.amount)
      user_order.update_column(:status, 'Cancelled')
      OrderMailer.with(order: user_order, refund_id: refund.id).cancelled.deliver_later
      user_order.line_items.each do |line_item|
        line_item.deal.increment!(:quantity)
      end
    end
  end

  private 

  def set_user
    @user = User.find_by(auth_token: params[:token])
  end
end
