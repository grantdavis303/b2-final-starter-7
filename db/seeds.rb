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
  name: "Free Fall 50",
  code: "$50_OFF_ALL",
  amount: 50,
  amount_type: 0,
  status: 0,
  merchant_id: 1 )

Coupon.create!(
  name: "Fourth Off Friday",
  code: "25%_OFF_SELECT",
  amount: 25,
  amount_type: 1,
  status: 0,
  merchant_id: 1 )

Coupon.create!(
  name: "Basically Free",
  code: "99%_OFF_EVERYTHING",
  amount: 99,
  amount_type: 1,
  status: 0,
  merchant_id: 1 )

Coupon.create!(
  name: "Random Off Coupon #1",
  code: "RANDOFF1",
  amount: rand(10..99),
  amount_type: 1,
  status: 0,
  merchant_id: 1 )

Coupon.create!(
  name: "Random Off Coupon #2",
  code: "RANDOFF2",
  amount: rand(10..99),
  amount_type: 1,
  status: 1,
  merchant_id: 1 )

Coupon.create!(
  name: "Cool 20 Off Coupon",
  code: "$20_OFF_2024",
  amount: 20,
  amount_type: 1,
  status: 1,
  merchant_id: 2 )

puts " "
puts "Coupons created."

# Link Invoices to Coupons
Rake::Task["link:invoices_and_coupons"].invoke

puts "Coupons and invoices linked."