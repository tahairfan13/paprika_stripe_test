# paprikas_rails_stripe_test
# Project Name
Paprikas Rails stripe api test

- Ruby 3.2.2
- Rails 7.1.2
- Bundler 2.4.22

## Installation

1. Clone or fork the repo
2. run `bundle install`
3. run `rails db:setup`
4. run `rspec` to run test cases

## Need you add stripe credentials in master file
1. i know `master.key` is secret key, but it's test and keys are also from test mode so you can use my master key for now `6290495ffbb906c39a1e29cbddac48d6` OR follow the process given below.
2. run command ` EDITOR="nano --wait" rails credentials:edit`, you can use your favourite editor by change name of `nano`
3. add these keys in stripe
```
stripe:
  public_key: pk_test_
  secret_key: sk_test_
  endpoint_secret: whsec_
```
