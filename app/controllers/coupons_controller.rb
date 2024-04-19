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
    new_coupon.save # implement sad path testing

    redirect_to merchant_coupons_path(@merchant)
  end

  private
  def coupon_params
    params
    .permit(:name, :code, :amount, :amount_type)
    .with_defaults(status: :disabled)
  end
end