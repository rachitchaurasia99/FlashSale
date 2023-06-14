class Api::DealsController < Api::BaseController

  def live 
    render json: Deal.live.map(&:serialize)
  end

  def past
    render json: Deal.expired.map(&:serialize)
  end

  private 

  def set_deal
    @deal = Deal.find_by(id: params[:id])
    redirect_to admin_deals_path, notice: "Deal Not found" unless @deal
  end

  def deal_params
    params.require(:deal).permit(:title, :description, :publishable, :quantity, :price_in_cents, :discount_price_in_cents, :publish_date, :published_date, :deals_tax, deal_images_attributes: [:image] )
  end 
end
