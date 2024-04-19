# [Coupon Codes](https://young-badlands-19401-fff924f631aa.herokuapp.com/)
### Grant Davis

Hi, my name is Grant and this is my Coupon Codes project.

To set up this code locally, run the following commands:

```
$ bundle install
$ rails db:{drop,create,migrate,seed}
# $ bundle exec rake csv_load:all
```

### Evaluation

[Link to Evaluation Rubric](https://backend.turing.edu/module2/projects/coupon_codes/evaluation)

- [ ] Complete All User Stories
- [ ] Students use the principles of MVC to effectively organize code with only 1 - 2 infractions. Routes and Actions mostly follow RESTful conventions
- [ ] ActiveRecord helpers are utilized most of the time. More complex ActiveRecord (joining, grouping, aggregating) is used to process data at least once. Queries are functional and accurate.
- [ ] 100% coverage for models. 
- [ ] 98% coverage for features. 
- [ ] Tests are well written and meaningful. All tests passing. TDD Process is clear throughout commits. Some effective sad path and edge case testing. Tests utilize within blocks to target specific areas of a page.

### Consolidated User Story Progress

[Link to User Stories](https://backend.turing.edu/module2/projects/coupon_codes/#user-stories)


- [x] User Story 0 - Deploy to Heroku
- [ ] User Story 1 - Merchant Coupons Index
- [ ] User Story 2 - Merchant Coupon Create
- [ ] User Story 3 - Merchant Coupon Show Page
- [ ] User Story 4 - Merchant Coupon Deactivate
- [ ] User Story 5 - Merchant Coupon Activate
- [ ] User Story 6 - Merchant Coupon Index Sorted
- [ ] User Story 7 - Merchant Invoice Show Page: Subtotal and Grand Total Revenues 
- [ ] User Story 8 - Admin Invoice Show Page: Subtotal and Grand Total Revenues

### Notes

```
Bug 1: FIXED

Solution: Added a within block to section off a part of the invoice so there would be no interference

Problem: Admin Invoices Index Page:53 will sometimes throw an error because the number can randomly appear in the randomly generated Invoice #
```
```
Had to change the schema to allow nil values for invoice_id, and thus had to change some of the validation testing to "allow blank and nil"
```