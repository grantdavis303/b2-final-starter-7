require "rails_helper"

RSpec.describe "coupon show page" do
  before :each do
    @merchant1 = Merchant.create!(name: "Hair Care")

    @customer_1 = Customer.create!(first_name: "Joey", last_name: "Smith")
    @customer_2 = Customer.create!(first_name: "Cecilia", last_name: "Jones")
    @customer_3 = Customer.create!(first_name: "Mariah", last_name: "Carrey")
    @customer_4 = Customer.create!(first_name: "Leigh Ann", last_name: "Bron")
    @customer_5 = Customer.create!(first_name: "Sylvester", last_name: "Nader")
    @customer_6 = Customer.create!(first_name: "Herber", last_name: "Kuhn")

    @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2)
    @invoice_2 = Invoice.create!(customer_id: @customer_1.id, status: 2)
    @invoice_3 = Invoice.create!(customer_id: @customer_2.id, status: 2)
    @invoice_4 = Invoice.create!(customer_id: @customer_3.id, status: 2)
    @invoice_5 = Invoice.create!(customer_id: @customer_4.id, status: 2)
    @invoice_6 = Invoice.create!(customer_id: @customer_5.id, status: 2)
    @invoice_7 = Invoice.create!(customer_id: @customer_6.id, status: 1)

    @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id)
    @item_2 = Item.create!(name: "Conditioner", description: "This makes your hair shiny", unit_price: 8, merchant_id: @merchant1.id)
    @item_3 = Item.create!(name: "Brush", description: "This takes out tangles", unit_price: 5, merchant_id: @merchant1.id)
    @item_4 = Item.create!(name: "Hair tie", description: "This holds up your hair", unit_price: 1, merchant_id: @merchant1.id)

    @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 1, unit_price: 10, status: 0)
    @ii_2 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_2.id, quantity: 1, unit_price: 8, status: 0)
    @ii_3 = InvoiceItem.create!(invoice_id: @invoice_2.id, item_id: @item_3.id, quantity: 1, unit_price: 5, status: 2)
    @ii_4 = InvoiceItem.create!(invoice_id: @invoice_3.id, item_id: @item_4.id, quantity: 1, unit_price: 5, status: 1)
    @ii_5 = InvoiceItem.create!(invoice_id: @invoice_4.id, item_id: @item_4.id, quantity: 1, unit_price: 5, status: 1)
    @ii_6 = InvoiceItem.create!(invoice_id: @invoice_5.id, item_id: @item_4.id, quantity: 1, unit_price: 5, status: 1)
    @ii_7 = InvoiceItem.create!(invoice_id: @invoice_6.id, item_id: @item_4.id, quantity: 1, unit_price: 5, status: 1)

    @transaction1 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: @invoice_1.id)
    @transaction2 = Transaction.create!(credit_card_number: 230948, result: 1, invoice_id: @invoice_3.id)
    @transaction3 = Transaction.create!(credit_card_number: 234092, result: 1, invoice_id: @invoice_4.id)
    @transaction4 = Transaction.create!(credit_card_number: 230429, result: 1, invoice_id: @invoice_5.id)
    @transaction5 = Transaction.create!(credit_card_number: 102938, result: 1, invoice_id: @invoice_6.id)
    @transaction6 = Transaction.create!(credit_card_number: 879799, result: 1, invoice_id: @invoice_7.id)
    @transaction7 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: @invoice_2.id)

    @coupon_1 = Coupon.create!(
      name: "Coupon 1",
      code: "$50_OFF_ALL",
      amount: 50,
      amount_type: 0,
      status: 0,
      merchant_id: @merchant1.id )
    
    @coupon_2 = Coupon.create!(
      name: "Coupon 2",
      code: "25%_OFF_SELECT",
      amount: 25,
      amount_type: 1,
      status: 1,
      merchant_id: @merchant1.id )
  end

  # User Story 3 
  it "has the coupon name, code, status, and count of usage" do
    # As a merchant, when I visit a merchant's coupon show page
    visit merchant_coupon_path(@merchant1, @coupon_1)

    within ".coupon_information" do
      # I see that coupon's name
      expect(page).to have_content(@coupon_1.name)
      # I see that coupon's code
      expect(page).to have_content(@coupon_1.code)
      # And I see the percent/dollar off value      
      expect(page).to have_content(@coupon_1.formatted_amount)
      # As well as its status (active or inactive)      
      expect(page).to have_content(@coupon_1.status)
      # And I see a count of how many times that coupon has been used.
      # expect(page).to have_content(@coupon_1.usage_count)      
    end
    # (Note: "use" of a coupon should be limited to successful transactions.)
  end

  # User Story 4
  it "has button to deactivate a coupon" do
    visit merchant_coupon_path(@merchant1, @coupon_1)
    # As a merchant, when I visit one of my active coupon's show pages 
    # I see a button to deactivate that coupon
    within ".coupon_buttons" do
      expect(page).to have_button("Deactivate Coupon")
    end
    # When I click that button, I'm taken back to the coupon show page 
    click_button("Deactivate Coupon")
    expect(current_path).to eq(merchant_coupon_path(@merchant1, @coupon_1))

    # And I can see that its status is now listed as 'inactive'.
    within ".coupon_information" do
      expect(page).to have_content("disabled")
    end

    # * Sad Paths to consider: 
    # 1. A coupon cannot be deactivated if there are any pending invoices with that coupon.
  end

  # User Story 5
  it "has button to activate a coupon" do
    visit merchant_coupon_path(@merchant1, @coupon_2)
    # As a merchant, when I visit one of my inactive coupon show pages
    # I see a button to activate that coupon
    within ".coupon_buttons" do
      expect(page).to have_button("Activate Coupon")
    end
    # When I click that button, I'm taken back to the coupon show page
    click_button("Activate Coupon")
    expect(current_path).to eq(merchant_coupon_path(@merchant1, @coupon_2))
    # And I can see that its status is now listed as 'active'.
    within ".coupon_information" do
      expect(page).to have_content("enabled")
    end
  end

  # Sad Path 1
  it "cannot activate a coupon when there are five active ones" do
    @coupon_3 = Coupon.create!( name: "Coupon 3", code: "$45_OFF_ALL", amount: 45, amount_type: 0, status: 0, merchant_id: @merchant1.id )
    @coupon_4 = Coupon.create!( name: "Coupon 4", code: "$25_OFF_ALL", amount: 25, amount_type: 0, status: 0, merchant_id: @merchant1.id )
    @coupon_5 = Coupon.create!( name: "Coupon 5", code: "$20_OFF_ALL", amount: 20, amount_type: 0, status: 0, merchant_id: @merchant1.id )
    @coupon_6 = Coupon.create!( name: "Coupon 6", code: "$10_OFF_ALL", amount: 10, amount_type: 0, status: 0, merchant_id: @merchant1.id )

    visit merchant_coupon_path(@merchant1, @coupon_2)

    within ".coupon_buttons" do
      expect(page).not_to have_button("Activate Coupon")
      expect(page).to have_content("Unable to activate coupon. Please deactivate a coupon and try again.")
    end
  end


end