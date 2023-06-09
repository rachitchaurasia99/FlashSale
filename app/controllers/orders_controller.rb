class OrdersController < ApplicationController
  before_action :set_order, only: %i[show edit update destroy payment success cancel]
  
  def index
    @orders = Order.all
    @orders = Order.where(user_id: params[:user_id]).where(status: 'Placed') if params[:user_id]
  end

  def new
    @order = Order.new
  end

  def show
  end

  def create
    @order = Order.new(order_params)
    if @order.save
      redirect_to root_path, notice: "Order was successfully placed."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @order.build_address
    if @order.update(order_params)
      payment
    else
      render :checkout 
    end
  end

  def destroy
    if @order.destroy
      redirect_to root_path, notice: "Order was successfully cancelled."
    else
      render :new, status: :unprocessable_entity 
    end
  end

  def cart
    @order = current_order
    if @order.line_items.empty?
      redirect_to root_path, alert: "You have no deals selected"
    end
  end

  def checkout
    @order = current_order
    @order.build_address
  end

  def payment
    deal = @order.line_items.map do |line_item|
      { quantity: 1,
        price_data: {
          currency: 'inr',
          unit_amount: line_item.unit_price.to_i,
          product_data: { 
            name: line_item.deal.title 
          }
        }
      }
    end

    session = Stripe::Checkout::Session.create( 
      line_items: deal,
      mode: 'payment',
      success_url:  success_order_url,
      cancel_url: cancel_order_url
    )
    @order.create_payment(transaction_id: session.id, currency: session.currency, status: 'Pending', type: 'Payment', total_amount_in_cents: @order.order_total)
    redirect_to session.url, allow_other_host: true
  end

  def success
    @order.update_column(:status, 'Placed')
    @order.payment.update_column(:status, 'Successful')
    OrderMailer.received(Order.last).deliver_later
  end

  def cancel
    @order.payment.update_column(status: 'Cancelled')
  end

  private 

  def set_order
    @order = Order.find_by(id: params[:id])
    redirect_to root_path, alert: "Order Not found" unless @order
  end

  def order_params
    params.require(:order).permit( :status , :address_id, address_attributes: [:name, :email, :user_id, :city, :state, :country, :pincode] )
  end 
end