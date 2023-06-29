class StripeRefundHandler
  def initialize(order)
    @order = order
  end

  def create_refund
    Stripe::Refund.create({
      payment_intent: get_payment_intent
    })
  end

  def get_payment_intent
    Stripe::PaymentIntent.retrieve(@order.payments.successful.first.payment_intent)
  end
end
