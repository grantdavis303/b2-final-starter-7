require 'rails_helper'

RSpec.describe Coupon, type: :model do
  describe "relationships" do
    it { should belong_to(:merchant) }
    it { should belong_to(:invoice).optional }
  end

  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:code) }  
    it { should validate_presence_of(:amount) }
    it { should validate_presence_of(:amount_type) }
    it { should validate_presence_of(:status) }
    it { should validate_presence_of(:merchant_id) }
    it { should allow_value("", nil).for(:invoice_id) }
    it { should validate_numericality_of(:amount) }
  end

  describe "instance methods" do
    it "#formatted_amount" do
      @merchant1 = Merchant.create!(name: "Hair Care")
      @coupon_1 = Coupon.create!(name: "Coupon 1", code: "$50_OFF_ALL", amount: 50, amount_type: 0, status: 0, merchant_id: @merchant1.id, invoice_id: nil )
      @coupon_2 = Coupon.create!(name: "Coupon 2", code: "25%_OFF_SELECT", amount: 25, amount_type: 1, status: 0, merchant_id: @merchant1.id, invoice_id: nil )
      expect(@coupon_1.formatted_amount).to eq("$50 OFF!")
      expect(@coupon_2.formatted_amount).to eq("25% OFF!")
    end

    it "#active_coupons" do
      @merchant1 = Merchant.create!(name: "Hair Care")
      @coupon_1 = Coupon.create!(name: "Coupon 1", code: "$50_OFF_ALL", amount: 50, amount_type: 0, status: 0, merchant_id: @merchant1.id, invoice_id: nil )
      @coupon_2 = Coupon.create!(name: "Coupon 2", code: "25%_OFF_SELECT", amount: 25, amount_type: 1, status: 1, merchant_id: @merchant1.id, invoice_id: nil )
      @coupon_3 = Coupon.create!(name: "Coupon 3", code: "65%_OFF", amount: 65, amount_type: 0, status: 0, merchant_id: @merchant1.id, invoice_id: nil )
      expect(@merchant1.active_coupons).to eq([@coupon_1, @coupon_3])
    end

    it "#inactive_coupons" do
      @merchant1 = Merchant.create!(name: "Hair Care")
      @coupon_1 = Coupon.create!(name: "Coupon 1", code: "$50_OFF_ALL", amount: 50, amount_type: 0, status: 1, merchant_id: @merchant1.id, invoice_id: nil )
      @coupon_2 = Coupon.create!(name: "Coupon 2", code: "25%_OFF_SELECT", amount: 25, amount_type: 1, status: 1, merchant_id: @merchant1.id, invoice_id: nil )
      @coupon_3 = Coupon.create!(name: "Coupon 3", code: "65%_OFF", amount: 65, amount_type: 0, status: 0, merchant_id: @merchant1.id, invoice_id: nil )
      expect(@merchant1.inactive_coupons).to eq([@coupon_1, @coupon_2])
    end
  end
end