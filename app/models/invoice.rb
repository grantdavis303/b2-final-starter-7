class Invoice < ApplicationRecord
  validates_presence_of :status,
                        :customer_id

  validates :coupon_id, presence: true, allow_blank: true

  belongs_to :customer
  belongs_to :coupon, optional: true
  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :merchants, through: :items

  enum status: [:cancelled, :in_progress, :completed]

  def total_revenue
    invoice_items.sum("unit_price * quantity")
  end

  def calculate_dollar_grand_total
    grand_total = self.total_revenue - (coupon.amount * 100) # Multiplying coupon amount by 100
    if grand_total <= 0                                      # since the amount is in dollars
      grand_total = 0                                        # and unit price on invoice is in cents
    end
    grand_total
  end

  def calculate_percent_grand_total
    grand_total = self.total_revenue - ((coupon.amount.to_f / 100) * self.total_revenue)
    if grand_total <= 0
      grand_total = 0
    end
    grand_total
  end
end
