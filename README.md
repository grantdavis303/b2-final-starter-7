# Coupon Codes

### There is currently no live deployment of this application.

To set up this code locally, run the following commands in your terminal:

```
$ bundle install
$ rails db:{drop,create,migrate,seed}
```
This command will create a new database, import data from many different CSVs (merchants, items, transactions etc), as well as create a few default coupons and apply them to a few invoices for Merchant #1 (to see functionality right away).

### Evaluation

[Link to Evaluation Rubric](https://backend.turing.edu/module2/projects/coupon_codes/evaluation)

- [x] Complete All User Stories
- [x] Students use the principles of MVC to effectively organize code with only 1 - 2 infractions. Routes and Actions mostly follow RESTful conventions
- [x] ActiveRecord helpers are utilized most of the time. More complex ActiveRecord (joining, grouping, aggregating) is used to process data at least once. Queries are functional and accurate.
- [x] 100% coverage for models. 
- [x] 98% coverage for features. 
- [x] Tests are well written and meaningful. All tests passing. TDD Process is clear throughout commits. Some effective sad path and edge case testing. Tests utilize within blocks to target specific areas of a page.

### Consolidated User Story Progress

[Link to User Stories](https://backend.turing.edu/module2/projects/coupon_codes/#user-stories)

- [x] User Story 0 - Deploy to Heroku
- [x] User Story 1 - Merchant Coupons Index
- [x] User Story 2 - Merchant Coupon Create
- [x] User Story 3 - Merchant Coupon Show Page
- [x] User Story 4 - Merchant Coupon Deactivate
- [x] User Story 5 - Merchant Coupon Activate
- [x] User Story 6 - Merchant Coupon Index Sorted
- [x] User Story 7 - Merchant Invoice Show Page: Subtotal and Grand Total Revenues 
- [x] User Story 8 - Admin Invoice Show Page: Subtotal and Grand Total Revenues

### Utilized Sad Paths

#### When creating a coupon:

* An error is thrown on Create Coupon when no field is filled in
* An error is thrown on Create Coupon when all but one field is filled in (name, code, amount, amount type)
* An error is thrown on Create Coupon when the amount is not a number
* An error is thrown on Create Coupon when the code is not unique

#### When enabling a coupon:

* An error is thrown on Activate Coupon when the merchant has 5 coupons already enabled

### Tests

* 154 Tests Total (100% coverage on 1592 LOC)
* 77 Model Tests (100% coverage on 525 LOC)
* 77 Feature Tests (100% coverage on 1205 LOC)

### Notes

```
Bug 1: FIXED

Solution: Added a within block to section off a part of the invoice so there would be no interference

Problem: Admin Invoices Index Page:53 will sometimes throw an error because the number can randomly appear in the randomly generated Invoice #
```
```
Had to change the schema to allow nil values for coupon_id on Invoices, and thus had to change some of the validation testing to "allow blank and nil"
```
```
Went back and added a migration for coupon_id to appear in invoices
```