class Admin::ReportsController < Admin::BaseController
  def index
  end

  def deals
    @deals = Deal.deals_with_revenue
    flash[:notice] = 'No customers found' if @deals.empty?
  end

  def customers
    if params[:from].present? && params[:to].present?
      @customers = User.customers_orders(params[:from], params[:to])
    elsif params[:from].present?
      @customers = User.customers_orders(params[:from])
    elsif params[:to].present?
      @customers = User.customers_orders(Date.new(0), params[:to])
    else
      @customers = User.customers_orders
    end
  end
end
