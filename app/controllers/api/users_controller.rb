class Api::UsersController < Api::BaseController
  before_action :find_user_by_auth_token, only: %i[my_orders]
  
  def my_orders 
    render json: @user.orders, each_serializer: OrderSerializer
  end
end
