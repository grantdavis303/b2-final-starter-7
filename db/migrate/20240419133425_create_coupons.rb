class CreateCoupons < ActiveRecord::Migration[7.1]
  def change
    create_table :coupons do |t|
      t.string :name
      t.string :code
      t.integer :amount
      t.integer :amount_type
      t.integer :status
      t.references :merchant, null: false, foreign_key: true

      t.timestamps
    end
  end
end
