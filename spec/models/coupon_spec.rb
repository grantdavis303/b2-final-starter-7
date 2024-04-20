require 'rails_helper'

RSpec.describe Coupon, type: :model do
  describe "relationships" do
    it { should belong_to(:merchant) }
  end

  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:code) }  
    it { should validate_presence_of(:amount) }
    it { should validate_presence_of(:amount_type) }
    it { should validate_presence_of(:status) }
    it { should validate_presence_of(:merchant_id) }
    # validate uniqueness of code
    it { should validate_numericality_of(:amount) }
  end

  describe "instance methods" do
    it "#formatted_amount" do
      @merchant1 = Merchant.create!(name: "Hair Care")
      @coupon_1 = Coupon.create!(name: "Coupon 1", code: "$50_OFF_ALL", amount: 50, amount_type: 0, status: 0, merchant_id: @merchant1.id )
      @coupon_2 = Coupon.create!(name: "Coupon 2", code: "25%_OFF_SELECT", amount: 25, amount_type: 1, status: 0, merchant_id: @merchant1.id )
      expect(@coupon_1.formatted_amount).to eq("$50 OFF!")
      expect(@coupon_2.formatted_amount).to eq("25% OFF!")
    end
  end
end