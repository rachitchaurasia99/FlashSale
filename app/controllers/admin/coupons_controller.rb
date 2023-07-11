class Admin::CouponsController < Admin::BaseController
  before_action :set_coupon, only: %i[active inactive]

  def index
    @coupons = Coupon.all
  end

  def new
    @coupon = Coupon.new
  end

  def create
    @coupon = Coupon.new(coupon_params)
    if @coupon.save
      redirect_to admin_coupons_path, notice: 'Coupon was successfully added'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def active
    Coupon.transaction do
      Coupon.update_all(status: inactive)
      @coupon.active!
    end
  
    redirect_back fallback_location: admin_coupons_path, notice: 'Coupon activated successfully.'
  end

  def inactive
    @coupon.inactive!
    redirect_back fallback_location: admin_coupons_path, notice: 'Coupon deactivated successfully.'
  end

  private

  def set_coupon
    @coupon = Coupon.find(params[:id])
  end

  def coupon_params
    params.require(:coupon).permit(:coupon_type, :currency, :value)
  end
end
