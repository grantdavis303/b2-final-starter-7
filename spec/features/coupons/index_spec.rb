require "rails_helper"

RSpec.describe "coupon index" do
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
      merchant_id: @merchant1.id,
      invoice_id: nil )
    
    @coupon_2 = Coupon.create!(
      name: "Coupon 2",
      code: "25%_OFF_SELECT",
      amount: 25,
      amount_type: 1,
      status: 0,
      merchant_id: @merchant1.id,
      invoice_id: nil )

    visit merchant_coupons_path(@merchant1)
  end

  it "has a section for all coupons with names and formatted amount off" do
    expect(current_path).to eq("/merchants/#{@merchant1.id}/coupons")

    within ".merchant_coupons" do
      within "#merchant_coupon_#{@coupon_1.id}" do
        expect(page).to have_link(@coupon_1.name)
        expect(page).to have_content(@coupon_1.name)
        expect(page).to have_content(@coupon_1.formatted_amount)
      end
      
      within "#merchant_coupon_#{@coupon_2.id}" do
        expect(page).to have_link(@coupon_2.name)
        expect(page).to have_content(@coupon_2.name)
        expect(page).to have_content(@coupon_2.formatted_amount)
      end
    end
  end

  it "can see a link to create a merchant coupon" do
    expect(page).to have_link("Create Coupon")

    click_link "Create Coupon"

    expect(current_path).to eq("/merchants/#{@merchant1.id}/coupons/new")
  end

  # User Story 2
  describe "links to a coupon create page" do
    it "links to a coupon create page that creates a new coupon when properly filled out" do # Good Path
      # As a merchant, when I visit my coupon index page 
      # I see a link to create a new coupon (tested in test above).
      # When I click that link
      within ".new_merchant_coupon" do
        click_link "Create Coupon"
      end
      # I am taken to a new page where I see a form to add a new coupon.
      expect(current_path).to eq("/merchants/#{@merchant1.id}/coupons/new")

      within ".new_coupon_form" do
        expect(page).to have_content("Coupon Name:")
        expect(page).to have_field(:name)
        expect(page).to have_content("Coupon Code:")
        expect(page).to have_field(:code)
        expect(page).to have_content("Coupon Amount:")
        expect(page).to have_field(:amount)
        expect(page).to have_content("Is this amount in dollars off or a percentage off?")
        expect(page).to have_content("Dollars ($)")
        expect(page).to have_content("Percentage (%)")
        expect(page).to have_unchecked_field(:amount_type)        
        expect(page).to have_button("Create Coupon")
      end
      
      # When I fill in that form with a name, unique code, an amount, and whether that amount is a percent or a dollar amount and click the Submit button
      within ".new_coupon_form" do
        fill_in :name, with: "Dope Fall Coupon 1"
        fill_in :code, with: "75OFFALL2024"
        fill_in :amount, with: 75
        choose :amount_type_dollar
        click_button "Create Coupon"
      end

      # I'm taken back to the coupon index page and I can see my new coupon listed.
      expect(current_path).to eq("/merchants/#{@merchant1.id}/coupons")

      within ".merchant_coupons" do
        expect(page).to have_content("Dope Fall Coupon 1")
        expect(page).to have_content("$75 OFF!")
      end
    end

    it "links to a coupon create page that doesn't creates a new coupon when improperly filled out" do # Bad Path
      # * Sad Paths to consider: 
      # 1. This Merchant already has 5 active coupons
      # 2. Coupon code entered is NOT unique      
    end
  end





end