require 'rails_helper'

RSpec.describe Coupon, type: :model do
  describe "validations" do
    subject {
      @merchant1 = Merchant.create!(name: "Hair Care")
      @coupon_1 = Coupon.new(merchant_id: @merchant1.id)
    }
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:code) }  
    it { should validate_presence_of(:amount) }
    it { should validate_presence_of(:amount_type) }
    it { should validate_presence_of(:status) }
    it { should validate_presence_of(:merchant_id) }
    it { should validate_uniqueness_of(:code) }
    it { should validate_numericality_of(:amount) }
  end

  describe "relationships" do
    it { should belong_to(:merchant) }
  end

  describe "instance methods" do
    it "#formatted_amount" do
      @merchant1 = Merchant.create!(name: "Hair Care")
      @coupon_1 = Coupon.create!(name: "Coupon 1", code: "$50_OFF_ALL", amount: 50, amount_type: 0, status: 0, merchant_id: @merchant1.id )
      @coupon_2 = Coupon.create!(name: "Coupon 2", code: "25%_OFF_SELECT", amount: 25, amount_type: 1, status: 0, merchant_id: @merchant1.id )
      expect(@coupon_1.formatted_amount).to eq("$50 OFF!")
      expect(@coupon_2.formatted_amount).to eq("25% OFF!")
    end

    it "#usage_count" do
      @customer = Customer.create!(first_name: 'Joey', last_name: 'Smith')
      @merchant1 = Merchant.create!(name: "Hair Care")
      @coupon_1 = Coupon.create!(name: "Coupon 1", code: "$50_OFF_ALL", amount: 50, amount_type: 0, status: 0, merchant_id: @merchant1.id )
      @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id, status: 1)
      @invoice_1 = Invoice.create!(customer_id: @customer.id, status: 2, coupon_id: @coupon_1.id)
      @invoice_2 = Invoice.create!(customer_id: @customer.id, status: 2, coupon_id: @coupon_1.id)
      @invoice_3 = Invoice.create!(customer_id: @customer.id, status: 2, coupon_id: @coupon_1.id)      
      @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 9, unit_price: 10, status: 0, created_at: "2012-03-27 14:54:09")
      @ii_2 = InvoiceItem.create!(invoice_id: @invoice_2.id, item_id: @item_1.id, quantity: 2, unit_price: 10, status: 0, created_at: "2012-03-29 14:54:09")
      @ii_3 = InvoiceItem.create!(invoice_id: @invoice_3.id, item_id: @item_1.id, quantity: 4, unit_price: 10, status: 0, created_at: "2012-03-29 14:54:09")
      @ii_4 = InvoiceItem.create!(invoice_id: @invoice_2.id, item_id: @item_1.id, quantity: 4, unit_price: 10, status: 0, created_at: "2012-03-29 14:54:09")
      @ii_5 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 8, unit_price: 10, status: 0, created_at: "2012-03-29 14:54:09")
      @transaction1 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: @invoice_1.id)
      @transaction2 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: @invoice_2.id)
      @transaction3 = Transaction.create!(credit_card_number: 203942, result: 0, invoice_id: @invoice_3.id)
      expect(@coupon_1.usage_count).to eq(2)
    end
  end
end