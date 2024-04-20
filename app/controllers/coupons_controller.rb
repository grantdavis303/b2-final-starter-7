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

    if new_coupon.save
      redirect_to merchant_coupons_path(@merchant)
    else
      flash.now[:notice] = new_coupon.errors.full_messages.to_sentence
      render :new
    end
  end

  def update
    @merchant = Merchant.find(params[:merchant_id])
    @coupon = Coupon.find(params[:id])

    @coupon.update({
      status: params[:new_status]
    })

    redirect_to merchant_coupon_path(@merchant, @coupon)
  end

  private
  def coupon_params
    params
    .permit(:name, :code, :amount, :amount_type)
    .with_defaults(status: :disabled)
  end
end