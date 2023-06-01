class Admin::DealsController < ApplicationController
  before_action :check_admin
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
    respond_to do |format|
      if @deal.save
        format.html { redirect_to admin_deal_path(@deal), notice: "Deal was successfully created." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format| 
      if @deal.update(deal_params)
        format.html { redirect_to admin_deal_url(@deal), notice: "Deal was successfully updated." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @deal.destroy
    respond_to do |format|
      format.html { redirect_to admin_deals_path, notice: "Deal was successfully destroyed." }
    end
  end

  def check_publishablity
    if @deal.valid?
      flash[:notice] = "Deal can be Published"
    else
      flash[:error] = 'Deal cannot be Published'
    end
    redirect_to admin_deals_path
  end

  private 

  def set_deal
    @deal = Deal.find(params[:id])
  end

  def deal_params
    params.require(:deal).permit(:title, :description, :publishable, :quantity, :price, :cents, :discount_cents, :publish_date, :published_date, :deals_tax, deal_images_attributes: [:image] )
  end

  def check_admin
    redirect_to store_homepage_path unless current_user.admin?
  end
   
end
