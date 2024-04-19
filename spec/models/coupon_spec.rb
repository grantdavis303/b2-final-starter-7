require 'rails_helper'

RSpec.describe Coupon, type: :model do
  describe "relationships" do
    it { should belong_to(:merchant) }
    it { should belong_to(:invoice).optional }
  end

  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:code) }
    it { should validate_presence_of(:amount) }
    it { should validate_presence_of(:type) }
    it { should validate_presence_of(:status) }
    it { should validate_presence_of(:merchant_id) }
    it { should validate_presence_of(:invoice_id) }
  end
end