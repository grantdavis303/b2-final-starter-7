class Coupon < ApplicationRecord
  validates_presence_of :name,
                        :code, #unique
                        :amount,
                        :amount_type,
                        :status,
                        :merchant_id

  # validate uniqunnss of code
  validates_numericality_of :amount                        

  belongs_to :merchant

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