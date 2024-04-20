class CouponsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
  end

  def show
    @merchant = Merchant.find(params[:merchant_id])
    @coupon = Coupon.find(params[:id])
  end

  def new
    @merchant = Merchant.find(params[:merchant_id])
  end

  def create
    @merchant = Merchant.find(params[:merchant_id])
    new_coupon = @merchant.coupons.new(coupon_params)

    if new_coupon.save # implement sad path testing
      redirect_to merchant_coupons_path(@merchant)
    else
      flash[:notice] = "Coupon not created: Information missing. Please fill in any empty fields."
      render :new
    end

    # if validates_uniqueness_of :number == "true"
    #   puts "this value is unique and should be added to the DB"
    # else 
    #   puts "this value is not unique and should not be added to the DB"
    # end

    # elsif params[:code]
    # elsif @merchant.active_coupons.count >= 5
  end

  private
  def coupon_params
    params
    .permit(:name, :code, :amount, :amount_type)
    .with_defaults(status: :disabled)
  end
end