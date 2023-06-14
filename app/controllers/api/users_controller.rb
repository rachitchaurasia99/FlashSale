class Api::UsersController < Api::BaseController
  before_action :set_user, only: %i[my_orders]
  
  def my_orders 
    render json: @user.orders.map(&:serialize)
  end

  private 

  def set_user
    @user = User.find_by(auth_token: params[:auth_token])
  end
end
