# finary

`finary` allows you to manipulate directly the [Finary](https://finary.com/) API, which is not officially released yet.

> Finary allows you to navigate the markets by centralizing your investments. It provides an effective way for you to get a clear overview of your asset allocation, especially if you invest in many different asset classes.

This gem is a working in progress project and has not a stable API yet. Its maturity is really alpha. It has been created for the developers who want to build some features around Finary:

* export all your Finary data
* import any data from any source not yet supported by Finary
* build extra reporting features

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'finary', github: 'abrisse/finary'
```

And then execute:

    $ bundle

## Usage

### Configuration

You can either provider a login/password or an access token.
If provided, the access token will be use in priority.

```ruby
require 'finary'

Finary.configure do |config|
  config.login = ENV['FINARY_LOGIN']
  config.password = ENV['FINARY_PASSWORD']
  config.access_token = ENV['FINARY_ACCESS_TOKEN']
end
```

### User class

The `User` class is the main class and represents a specific user. To work with the loggued user `me`, you can call `Finary.me`.

It allows to use the Finary API with a high level abstraction and returns only high level Ruby classes that relies on `Dry::Struct`.

```ruby
pp Finary.me.get_cryptos[0].attributes.keys

# [:id,
#  :crypto,
#  :owning_type,
#  :quantity,
#  :current_price,
#  :buying_price,
#  :current_value,
#  :unrealized_pnl,
#  :unrealized_pnl_percent,
#  :account]

pp Finary.me.get_generic_assets[0].attributes.keys

# [:id,
#  :name,
#  :updated_at,
#  :category,
#  :quantity,
#  :buying_price,
#  :current_price,
#  :current_value,
#  :unrealized_pnl,
#  :unrealized_pnl_percent]

pp Finary.me.get_holdings_accounts[0].attributes.keys

# [:slug,
#  :id,
#  :name,
#  :manual_type,
#  :last_sync_at,
#  :balance,
#  :transactions_count,
#  :upnl,
#  :upnl_percent,
#  :unrealized_pnl,
#  :unrealized_pnl_percent,
#  :bank,
#  :cryptos,
#  :securities,
#  :fonds_euro]

pp Finary.me.get_loans[0].attributes.keys

# [:id,
#  :loan_type,
#  :loan_category,
#  :name,
#  :month_duration,
#  :start_date,
#  :end_date,
#  :ownership_percentage,
#  :total_amount,
#  :loan_to_value,
#  :monthly_repayment,
#  :insurance_rate,
#  :fixed_costs,
#  :elapsed_months,
#  :remaining_months,
#  :outstanding_amount,
#  :outstanding_capital,
#  :contribution]

pp Finary.me.get_securities[0].attributes.keys

# [:id,
#  :security,
#  :quantity,
#  :current_value,
#  :unrealized_pnl,
#  :unrealized_pnl_percent,
#  :buying_price,
#  :account]

pp Finary.me.get_view_dashboard(type: 'finary', period: '1w').attributes.keys

# [:timeseries, :data, :last_user_sync_at]

pp Finary.me.get_view_portfolio(period: '1m').attributes.keys

# [:timeseries, :data, :last_user_sync_at]
```

### HTTP Client

The `Finary::Client` allows to request the Finary API directly
and returns the parsed JSON body.

```ruby
client = Finary.client

client.get_user_generic_assets
client.get_user_holdings_accounts
client.get_user_securities
client.get_user_cryptos
client.get_user_loans
client.get_user_view(:dashboard, type: 'finary', period: '1w')
````

## Development

After checking out the repo, run `bundle install --path .bundle` to install dependencies. Then, run `rake spec` to run the tests.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/abrisse/finary. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
