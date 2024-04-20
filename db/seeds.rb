# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

Rake::Task["csv_load:all"].invoke

# Create Coupons
Coupon.create!(
  name: "Coupon 1",
  code: "$50_OFF_ALL",
  amount: 50,
  amount_type: 0,
  status: 0,
  merchant_id: 1 )

Coupon.create!(
  name: "Coupon 2",
  code: "25%_OFF_SELECT",
  amount: 25,
  amount_type: 1,
  status: 0,
  merchant_id: 1 )

Coupon.create!(
  name: "Super Sweet Coupon #1",
  code: "99%_OFF_ERRYTHING",
  amount: 99,
  amount_type: 1,
  status: 0,
  merchant_id: 2 )

Coupon.create!(
  name: "Super Sweet Coupon #2",
  code: "RANDOFF24",
  amount: rand(10..75),
  amount_type: 1,
  status: 0,
  merchant_id: 2 )

puts " "
puts "Coupons Created Successfully"

# Link Invoices to Coupons
Rake::Task["link:invoices_and_coupons"].invoke

puts " "
puts "Coupons Added to Invoices"