class Coupon < ApplicationRecord
  validates_presence_of :name,
                        :code,
                        :amount,
                        :amount_type,
                        :status,
                        :merchant_id

  validates :invoice_id, presence: true, allow_blank: true
  
  belongs_to :merchant
  belongs_to :invoice, optional: true

  enum amount_type: [:dollar, :percent]
  enum status: [:enabled, :disabled]
end