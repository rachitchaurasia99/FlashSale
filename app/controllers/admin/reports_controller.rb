class Admin::ReportsController < Admin::BaseController
  def index
  end

  def deals
    @deals = Deal.deal_revenue
    flash[:notice] = 'No customers found' if @deals.empty?
  end

  def customers
    if params[:from] && params[:to]
      @customers = User.top_spending_customers(params[:from], params[:to])
      flash[:notice] = 'No customers found' if @customers.empty?
    end
  end
end
