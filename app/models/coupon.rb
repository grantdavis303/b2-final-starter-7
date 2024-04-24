class Coupon < ApplicationRecord
  validates_presence_of :name,
                        :code,
                        :amount,
                        :amount_type,
                        :status,
                        :merchant_id
  validates_uniqueness_of :code
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
    merchant.invoices
      .select("invoices.*")
      .joins(:transactions)
      .where("transactions.result = '1' AND invoices.coupon_id = #{self.id}")
      .group("invoices.id")
      .length
  end
end