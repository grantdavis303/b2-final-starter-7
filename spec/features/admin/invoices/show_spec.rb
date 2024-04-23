require "rails_helper"

describe "Admin Invoices Show Page" do
  before :each do
    @m1 = Merchant.create!(name: "Merchant 1")

    @c1 = Customer.create!(first_name: "Yo", last_name: "Yoz", address: "123 Heyyo", city: "Whoville", state: "CO", zip: 12345)
    @c2 = Customer.create!(first_name: "Hey", last_name: "Heyz")

    @coupon = Coupon.create!(name: "Coupon 1", code: "$1_OFF_ALL", amount: 1, amount_type: 0, status: 0, merchant_id: @m1.id)

    @i1 = Invoice.create!(customer_id: @c1.id, status: 2, created_at: "2012-03-25 09:54:09", coupon_id: @coupon.id)
    @i2 = Invoice.create!(customer_id: @c2.id, status: 1, created_at: "2012-03-25 09:30:09")

    @item_1 = Item.create!(name: "test", description: "lalala", unit_price: 6, merchant_id: @m1.id)
    @item_2 = Item.create!(name: "rest", description: "dont test me", unit_price: 12, merchant_id: @m1.id)

    @ii_1 = InvoiceItem.create!(invoice_id: @i1.id, item_id: @item_1.id, quantity: 1252, unit_price: 2, status: 0)
    @ii_2 = InvoiceItem.create!(invoice_id: @i1.id, item_id: @item_2.id, quantity: 356, unit_price: 1, status: 1)
    @ii_3 = InvoiceItem.create!(invoice_id: @i2.id, item_id: @item_2.id, quantity: 87, unit_price: 12, status: 2)

    visit admin_invoice_path(@i1)
  end

  it "should display the id, status and created_at" do
    expect(page).to have_content("Invoice ##{@i1.id}")
    expect(page).to have_content("Created on: #{@i1.created_at.strftime("%A, %B %d, %Y")}")

    expect(page).to_not have_content("Invoice ##{@i2.id}")
  end

  it "should display the customers name and shipping address" do
    expect(page).to have_content("#{@c1.first_name} #{@c1.last_name}")
    expect(page).to have_content(@c1.address)
    expect(page).to have_content("#{@c1.city}, #{@c1.state} #{@c1.zip}")

    expect(page).to_not have_content("#{@c2.first_name} #{@c2.last_name}")
  end

  it "should display all the items on the invoice" do
    within ".invoice_item_table" do
      expect(page).to have_content(@item_1.name)
      expect(page).to have_content(@item_2.name)

      expect(page).to have_content(@ii_1.quantity)
      expect(page).to have_content(@ii_2.quantity)

      expect(page).to have_content("$#{@ii_1.unit_price}")
      expect(page).to have_content("$#{@ii_2.unit_price}")

      expect(page).to have_content(@ii_1.status)
      expect(page).to have_content(@ii_2.status)

      expect(page).to_not have_content(@ii_3.quantity)
      expect(page).to_not have_content("$#{@ii_3.unit_price}")
      expect(page).to_not have_content(@ii_3.status)
    end
  end

  it "should display the total revenue the invoice will generate" do
    expect(page).to have_content("Total Revenue: $2,860.0")

    expect(page).to_not have_content(@i2.total_revenue)
  end

  it "should have status as a select field that updates the invoices status" do
    within("#status-update-#{@i1.id}") do
      select("cancelled", :from => "invoice[status]")
      expect(page).to have_button("Update Invoice")
      click_button "Update Invoice"

      expect(current_path).to eq(admin_invoice_path(@i1))
      expect(@i1.status).to eq("completed")
    end
  end

  # User Story 8
  it "shows subtotal and grand total for all invoices" do
  # As an admin, when I visit one of my admin invoice show pages
  visit admin_invoice_path(@i1)

  # I see the name and code of the coupon that was used (if there was a coupon applied)
  within ".applied_coupon_info" do
    expect(page).to have_content(@coupon.name)
    expect(page).to have_content(@coupon.code)
  end

  # And I see both the subtotal revenue from that invoice (before coupon) and the grand total revenue (after coupon) for this invoice.
  within ".invoice_totals" do
    expect(page).to have_content("Subtotal: $28.60")
    expect(page).to have_content("Grand Total: $27.60")
  end

  # * Alternate Paths to consider: 
  # 1. There may be invoices with items from more than 1 merchant. Coupons for a merchant only apply to items from that merchant.
  # 2. When a coupon with a dollar-off value is used with an invoice with multiple merchants' items, the dollar-off amount applies to the total amount even though there may be items present from another merchant.
  end

  # No coupon applied
  it "shows subtotal and grand total for all invoices" do
    visit admin_invoice_path(@i2)
  
    expect(page).to have_content("No coupon was used on this invoice.")
  end

end
