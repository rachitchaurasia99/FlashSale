class Admin::DealsController < Admin::BaseController
  before_action :set_deal, only: %i[show edit update destroy check_publishablity]
  
  def index
    @deals = Deal.all
  end

  def new
    @deal = Deal.new
  end

  def show
  end

  def edit
  end

  def create
    @deal = Deal.new(deal_params)
      if @deal.save
        redirect_to admin_deals_path, notice: "Deal was successfully created."
      else
        render :new, status: :unprocessable_entity
      end
  end

  def update
    if @deal.update(deal_params)
      redirect_to admin_deals_path, notice: "Deal was successfully updated."
    else
      render :new, status: :unprocessable_entity 
    end
  end

  def destroy
    if @deal.destroy
      redirect_to admin_deals_path, notice: "Deal was successfully destroyed."
    else
      render :new, status: :unprocessable_entity 
    end
  end

  def check_publishablity
    if @deal.check_publishablity
      flash[:notice] = "Deal can be Published"
    else
      flash[:error] = 'Deal cannot be Published'
    end
    redirect_to admin_deals_path
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