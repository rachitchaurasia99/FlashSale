class LineItemsController < ApplicationController
  before_action :set_line_item, only: [:destroy]
  before_action :get_deal, only: [:create]

  def new
  end

  def create
    if deal_exists?
      redirect_to root_path, alert: 'You can only buy one quantity of this deal'
    else
      @line_item = current_order.line_items.create(deal_id: @deal.id, quantity: 1, discount_price_in_cents: @deal.discount_price_in_cents, price_in_cents: @deal.price_in_cents)
      @deal.decrement!(:quantity, 1)
      if @deal.quantity.zero?
        ActionCable.server.broadcast(
          "deal_status_channel",
           {
             deal_id: @deal.id,
             quantity: @deal.quantity
           }
          )
      end
      redirect_to root_path, notice: 'Item Added'
    end
  end

  def deal_exists?
    current_order.line_items.find_by(deal_id: @deal.id)
  end

  def destroy
    @deal = Deal.find(@line_item.deal_id)
    quantity = @deal.quantity
    if @line_item.destroy
      @deal.increment!(:quantity, 1)
      if quantity.zero?
        ActionCable.server.broadcast(
          "deal_status_channel",
           {
             deal_id: @deal.id,
             quantity: @deal.quantity
           }
        )
      end
      redirect_to request.referer
    else
      render :new, status: :unprocessable_entity 
    end
  end

  private

  def get_deal
    @deal = Deal.find(params[:deal_id])
  end

  def set_line_item
    @line_item = LineItem.find(params[:id])
  end
end
