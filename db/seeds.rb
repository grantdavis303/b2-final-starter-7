# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

Rake::Task["csv_load:all"].invoke

# Create Coupons
print "Creating Coupons"

print "."
Coupon.create!(
  name: "Coupon 1",
  code: "$50_OFF_ALL",
  amount: 50,
  type: 0,
  status: 0,
  merchant_id: 1 )

print "."
Coupon.create!(
  name: "Coupon 2",
  code: "25%_OFF_SELECT",
  amount: 25,
  type: 1,
  status: 0,
  merchant_id: 1 )

puts " "
puts "Coupons Created Successfully"