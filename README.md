# AllpayInvoice

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/allpay_invoice`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'allpay_invoice'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install allpay_invoice

## Usage
init:

      @client = AllpayInvoice::Invoice.new(mode: :test)
create new invoice:

      @client.issue TimeStamp: Time.now.to_i,
          RelateNumber: SecureRandom.hex(6),
          CustomerIdentifier: '',
          CustomerName: 'bird的rspec',
          CustomerAddr: 'bird的rspec_address',
          CustomerPhone: '',
          CustomerEmail: 'bird1204@gmail.com',
          ClearanceMark: '',
          Print: '1',
          Donation: '2',
          CarruerType: '',
          CarruerNum: '',
          TaxType: '1',
          SalesAmount: 200,
          InvoiceRemark: 'remark備註',
          ItemName: '車子1|item2',
          ItemCount: '1|1',
          ItemWord: '個|份',
          ItemPrice: '100|100',
          ItemTaxType: '1|1',
          ItemAmount: '100|100',
          InvType: '07',
          InvCreateDate: Time.now.strftime('%Y-%m-%d %H:%M:%S')

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/[my-github-username]/allpay_invoice/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
