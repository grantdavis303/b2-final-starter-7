require "rails_helper"

RSpec.describe "invoices show" do
  before :each do
    @merchant1 = Merchant.create!(name: "Hair Care")
    @merchant2 = Merchant.create!(name: "Jewelry")

    @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id, status: 1)
    @item_2 = Item.create!(name: "Conditioner", description: "This makes your hair shiny", unit_price: 8, merchant_id: @merchant1.id)
    @item_3 = Item.create!(name: "Brush", description: "This takes out tangles", unit_price: 5, merchant_id: @merchant1.id)
    @item_4 = Item.create!(name: "Hair tie", description: "This holds up your hair", unit_price: 1, merchant_id: @merchant1.id)
    @item_7 = Item.create!(name: "Scrunchie", description: "This holds up your hair but is bigger", unit_price: 3, merchant_id: @merchant1.id)
    @item_8 = Item.create!(name: "Butterfly Clip", description: "This holds up your hair but in a clip", unit_price: 5, merchant_id: @merchant1.id)

    @item_5 = Item.create!(name: "Bracelet", description: "Wrist bling", unit_price: 200, merchant_id: @merchant2.id)
    @item_6 = Item.create!(name: "Necklace", description: "Neck bling", unit_price: 300, merchant_id: @merchant2.id)

    @customer_1 = Customer.create!(first_name: "Joey", last_name: "Smith")
    @customer_2 = Customer.create!(first_name: "Cecilia", last_name: "Jones")
    @customer_3 = Customer.create!(first_name: "Mariah", last_name: "Carrey")
    @customer_4 = Customer.create!(first_name: "Leigh Ann", last_name: "Bron")
    @customer_5 = Customer.create!(first_name: "Sylvester", last_name: "Nader")
    @customer_6 = Customer.create!(first_name: "Herber", last_name: "Kuhn")

    @coupon = Coupon.create!(name: "Coupon 1", code: "$1_OFF_ALL", amount: 1, amount_type: 0, status: 0, merchant_id: @merchant1.id )
    @coupon1 = Coupon.create!(name: "Coupon 2", code: "$50_OFF_ALL", amount: 50, amount_type: 0, status: 0, merchant_id: @merchant1.id )
    @coupon2 = Coupon.create!(name: "Coupon 3", code: "125%_OFF", amount: 100, amount_type: 1, status: 0, merchant_id: @merchant1.id )
    @coupon3 = Coupon.create!(name: "Coupon 4", code: "10%_OFF", amount: 10, amount_type: 1, status: 0, merchant_id: @merchant1.id )

    @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2, created_at: "2012-03-27 14:54:09", coupon_id: @coupon.id)
    @invoice_2 = Invoice.create!(customer_id: @customer_1.id, status: 2, created_at: "2012-03-28 14:54:09")
    @invoice_3 = Invoice.create!(customer_id: @customer_2.id, status: 2, created_at: "2012-03-27 14:54:09", coupon_id: @coupon1.id)
    @invoice_4 = Invoice.create!(customer_id: @customer_3.id, status: 2, created_at: "2012-03-27 14:54:09", coupon_id: @coupon2.id)
    @invoice_5 = Invoice.create!(customer_id: @customer_4.id, status: 2, created_at: "2012-03-27 14:54:09", coupon_id: @coupon3.id)
    @invoice_6 = Invoice.create!(customer_id: @customer_5.id, status: 2)
    @invoice_7 = Invoice.create!(customer_id: @customer_6.id, status: 2)

    @invoice_8 = Invoice.create!(customer_id: @customer_6.id, status: 1)

    @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 9, unit_price: 10, status: 2)
    @ii_2 = InvoiceItem.create!(invoice_id: @invoice_2.id, item_id: @item_1.id, quantity: 1, unit_price: 10, status: 2)
    @ii_3 = InvoiceItem.create!(invoice_id: @invoice_3.id, item_id: @item_2.id, quantity: 50, unit_price: 8, status: 2)
    @ii_4 = InvoiceItem.create!(invoice_id: @invoice_4.id, item_id: @item_3.id, quantity: 50, unit_price: 8, status: 1)
    @ii_6 = InvoiceItem.create!(invoice_id: @invoice_5.id, item_id: @item_4.id, quantity: 65, unit_price: 156, status: 1)
    @ii_7 = InvoiceItem.create!(invoice_id: @invoice_6.id, item_id: @item_7.id, quantity: 1, unit_price: 3, status: 1)
    @ii_8 = InvoiceItem.create!(invoice_id: @invoice_7.id, item_id: @item_8.id, quantity: 1, unit_price: 5, status: 1)
    @ii_9 = InvoiceItem.create!(invoice_id: @invoice_7.id, item_id: @item_4.id, quantity: 1, unit_price: 1, status: 1)
    @ii_10 = InvoiceItem.create!(invoice_id: @invoice_8.id, item_id: @item_5.id, quantity: 1, unit_price: 1, status: 1)
    @ii_11 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_8.id, quantity: 12, unit_price: 6, status: 1)

    @transaction1 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: @invoice_1.id)
    @transaction2 = Transaction.create!(credit_card_number: 230948, result: 1, invoice_id: @invoice_2.id)
    @transaction3 = Transaction.create!(credit_card_number: 234092, result: 1, invoice_id: @invoice_3.id)
    @transaction4 = Transaction.create!(credit_card_number: 230429, result: 1, invoice_id: @invoice_4.id)
    @transaction5 = Transaction.create!(credit_card_number: 102938, result: 1, invoice_id: @invoice_5.id)
    @transaction6 = Transaction.create!(credit_card_number: 879799, result: 0, invoice_id: @invoice_6.id)
    @transaction7 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: @invoice_7.id)
    @transaction8 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: @invoice_8.id)
  end

  it "shows the invoice information" do
    visit merchant_invoice_path(@merchant1, @invoice_1)

    expect(page).to have_content(@invoice_1.id)
    expect(page).to have_content(@invoice_1.status)
    expect(page).to have_content(@invoice_1.created_at.strftime("%A, %B %-d, %Y"))
  end

  it "shows the customer information" do
    visit merchant_invoice_path(@merchant1, @invoice_1)

    expect(page).to have_content(@customer_1.first_name)
    expect(page).to have_content(@customer_1.last_name)
    expect(page).to_not have_content(@customer_2.last_name)
  end

  it "shows the item information" do
    visit merchant_invoice_path(@merchant1, @invoice_1)

    expect(page).to have_content(@item_1.name)
    expect(page).to have_content(@ii_1.quantity)
    expect(page).to have_content("$0.10") # expect(page).to have_content(@ii_1.unit_price)
    expect(page).to_not have_content(@ii_4.unit_price)
  end

  it "shows the total revenue for this invoice" do
    visit merchant_invoice_path(@merchant1, @invoice_1)

    expect(page).to have_content("$1.62") # expect(page).to have_content(@invoice_1.total_revenue)
  end

  it "shows a select field to update the invoice status" do
    visit merchant_invoice_path(@merchant1, @invoice_1)

    within("#the-status-#{@ii_1.id}") do
      page.select("cancelled")
      click_button "Update Invoice"

      expect(page).to have_content("cancelled")
    end

    within("#current-invoice-status") do
      expect(page).to_not have_content("in progress")
    end
  end

  # User Story 7
  it "shows the subtotal and grand total before a discount is applied" do
    # As a merchant, when I visit one of my merchant invoice show pages
    visit merchant_invoice_path(@merchant1, @invoice_1)

    # I see the subtotal for my merchant from this invoice (that is, the total that does not include coupon discounts)
    # And I see the grand total revenue after the discount was applied
    within(".invoice_totals") do
      expect(page).to have_content("Subtotal: $1.62")
      expect(page).to have_content("Grand Total: $0.62")
    end
  
    # And I see the name and code of the coupon used as a link to that coupon's show page.
    within(".applied_coupon_info") do
      expect(page).to have_link(@coupon.name)
      expect(page).to have_content(@coupon.name)
      expect(page).to have_content(@coupon.code)
    end

    within(".applied_coupon_info") do
      click_link(@coupon.name)
      expect(current_path).to eq(merchant_coupon_path(@merchant1, @coupon))
    end
  end

  # Discount > Total Revenue (Dollars)
  it "discount is larger than total revenue - dollars" do
    visit merchant_invoice_path(@merchant1, @invoice_3)

    within(".invoice_totals") do
      expect(page).to have_content("Subtotal: $4.00")
      expect(page).to have_content("Grand Total: $0.00")
    end
  end

  # Discount < Total Revenue (Percentage)
  it "discount is less than total revenue - percentage" do
    visit merchant_invoice_path(@merchant1, @invoice_5)

    within(".invoice_totals") do
      expect(page).to have_content("Subtotal: $101.40")
      expect(page).to have_content("Grand Total: $91.26")
    end
  end

  # Discount > Total Revenue (Percentage)
  it "discount is larger than total revenue - percentage" do
    visit merchant_invoice_path(@merchant1, @invoice_4)

    within(".invoice_totals") do
      expect(page).to have_content("Subtotal: $4.00")
      expect(page).to have_content("Grand Total: $0.00")
    end
  end
end
