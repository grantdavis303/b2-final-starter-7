require 'rails_helper'

RSpec.describe Invoice, type: :model do
  describe "validations" do
    it { should validate_presence_of :status }
    it { should validate_presence_of :customer_id }
    it { should allow_value("", nil).for(:coupon_id) }
  end

  describe "relationships" do
    it { should belong_to :customer }
    it { should belong_to(:coupon).optional }
    it { should have_many :transactions}  
    it { should have_many :invoice_items} 
    it { should have_many(:items).through(:invoice_items) }
    it { should have_many(:merchants).through(:items) }
  end

  describe "instance methods" do
    it "#total_revenue" do
      @merchant1 = Merchant.create!(name: 'Hair Care')
      @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id, status: 1)
      @item_8 = Item.create!(name: "Butterfly Clip", description: "This holds up your hair but in a clip", unit_price: 5, merchant_id: @merchant1.id)
      @customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
      @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2, created_at: "2012-03-27 14:54:09")
      @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 9, unit_price: 10, status: 2)
      @ii_11 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_8.id, quantity: 1, unit_price: 10, status: 1)

      expect(@invoice_1.total_revenue).to eq(100)
    end

    # Returns Correct $ for Dollar Discount < Total_Revenue
    it "#calculate_dollar_grand_total" do
      @merchant1 = Merchant.create!(name: 'Hair Care')
      @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id, status: 1)
      @item_8 = Item.create!(name: "Butterfly Clip", description: "This holds up your hair but in a clip", unit_price: 5, merchant_id: @merchant1.id)
      @coupon_1 = Coupon.create!(name: "Coupon 1", code: "$50_OFF_ALL", amount: 50, amount_type: 0, status: 0, merchant_id: @merchant1.id )
      @customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
      @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2, created_at: "2012-03-27 14:54:09", coupon_id: @coupon_1.id)
      @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 96, unit_price: 130, status: 2)
      @ii_11 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_8.id, quantity: 43, unit_price: 120, status: 1)

      expect(@invoice_1.calculate_dollar_grand_total).to eq(12640)
    end

    # Returns 0 if Dollar Discount > Total_Revenue
    it "#calculate_dollar_grand_total" do
      @merchant1 = Merchant.create!(name: 'Hair Care')
      @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id, status: 1)
      @item_8 = Item.create!(name: "Butterfly Clip", description: "This holds up your hair but in a clip", unit_price: 5, merchant_id: @merchant1.id)
      @coupon_1 = Coupon.create!(name: "Coupon 1", code: "$5000_OFF_ALL", amount: 5000, amount_type: 0, status: 0, merchant_id: @merchant1.id )
      @customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
      @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2, created_at: "2012-03-27 14:54:09", coupon_id: @coupon_1.id)
      @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 96, unit_price: 130, status: 2)
      @ii_11 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_8.id, quantity: 43, unit_price: 120, status: 1)

      expect(@invoice_1.calculate_dollar_grand_total).to eq(0)
    end

    # Returns Correct $ for Percent Discount < 100
    it "#calculate_percent_grand_total" do
      @merchant1 = Merchant.create!(name: 'Hair Care')
      @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id, status: 1)
      @item_8 = Item.create!(name: "Butterfly Clip", description: "This holds up your hair but in a clip", unit_price: 5, merchant_id: @merchant1.id)
      @coupon_1 = Coupon.create!(name: "Coupon 1", code: "50%_OFF_ALL", amount: 50, amount_type: 1, status: 0, merchant_id: @merchant1.id )
      @customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
      @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2, created_at: "2012-03-27 14:54:09", coupon_id: @coupon_1.id)
      @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 96, unit_price: 130, status: 2)
      @ii_11 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_8.id, quantity: 43, unit_price: 120, status: 1)

      expect(@invoice_1.calculate_percent_grand_total).to eq(8820)
    end
    
    # Returns 0 if Percentage > 100
    it "#calculate_percent_grand_total" do
      @merchant1 = Merchant.create!(name: 'Hair Care')
      @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id, status: 1)
      @item_8 = Item.create!(name: "Butterfly Clip", description: "This holds up your hair but in a clip", unit_price: 5, merchant_id: @merchant1.id)
      @coupon_1 = Coupon.create!(name: "Coupon 1", code: "125%_OFF_ALL", amount: 125, amount_type: 1, status: 0, merchant_id: @merchant1.id )
      @customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
      @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2, created_at: "2012-03-27 14:54:09", coupon_id: @coupon_1.id)
      @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 96, unit_price: 130, status: 2)
      @ii_11 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_8.id, quantity: 43, unit_price: 120, status: 1)

      expect(@invoice_1.calculate_percent_grand_total).to eq(0)
    end

  end
end
