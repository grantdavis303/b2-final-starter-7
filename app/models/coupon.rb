class Coupon < ApplicationRecord
  validates_presence_of :name,
                        :code,
                        :amount,
                        :type,
                        :status,
                        :merchant_id,
                        :invoice_id
  
  belongs_to :merchant
  belongs_to :invoice, optional: true

  enum type: ["dollar", "percent"]
  enum status: ["enabled", "disabled"]
end