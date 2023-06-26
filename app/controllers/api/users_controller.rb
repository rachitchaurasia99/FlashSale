class Api::UsersController < Api::BaseController
  before_action :set_user, only: %i[my_orders]
  
  def my_orders 
    render json: @user.orders, each_serializer: OrderSerializer
  end
end
