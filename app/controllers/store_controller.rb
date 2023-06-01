class StoreController < ApplicationController
  skip_before_action :authenticate_user!
  def homepage
    @deals = Deal.where(publishable: true)
  end
end
