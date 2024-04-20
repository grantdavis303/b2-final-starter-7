class Coupon < ApplicationRecord
  validates_presence_of :name,
                        :code, #unique
                        :amount, #numericality
                        :amount_type,
                        :status,
                        :merchant_id
                        # invoice_id # can be blank
                        
  #validates :invoice_id, presence: true, allow_blank: true
  validates_numericality_of :amount

  belongs_to :merchant
  #belongs_to :invoice, optional: true

  enum amount_type: [:dollar, :percent]
  enum status: [:enabled, :disabled]

  def formatted_amount
    if amount_type == "dollar"
      "$#{amount} OFF!"
    elsif amount_type == "percent"
      "#{amount}% OFF!"
    end
  end

  def usage_count
    # merchant.invoices.where("coupon_id")
  end
end