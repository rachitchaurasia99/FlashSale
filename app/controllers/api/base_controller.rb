class Api::BaseController < ApplicationController
  skip_before_action :authenticate_user!

  private 

  def current_api_user
    @user = User.find_by(auth_token: params[:token])
    render json: { error: 'Token Malformed' }, status: 403 unless @user
  end
end
