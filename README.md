# finary [![Build Status](https://app.travis-ci.com/abrisse/finary.svg?branch=main)](https://app.travis-ci.com/abrisse/finary) [![Coverage Status](https://coveralls.io/repos/github/abrisse/finary/badge.svg?branch=main)](https://coveralls.io/github/abrisse/finary?branch=main) [![Maintainability](https://api.codeclimate.com/v1/badges/360633b09e5ae57b49af/maintainability)](https://codeclimate.com/github/abrisse/finary/maintainability)

`finary` allows you to manipulate directly the [Finary](https://finary.com/) API, which is not officially released yet.

> Finary allows you to navigate the markets by centralizing your investments. It provides an effective way for you to get a clear overview of your asset allocation, especially if you invest in many different asset classes.

This gem is a working in progress project and has not a stable API yet. Its maturity is really alpha. It has been created for the developers who want to build some features around Finary:

* export all your Finary data
* import any data from any source not yet supported by Finary
* build extra reporting features

It includes some extra features like external providers import (see [External Providers import](https://github.com/abrisse/finary#external-providers-import))

## Installation

Add this line to your application's Gemfile:

```ruby
source 'https://rubygems.org'

gem 'finary', git: 'https://github.com/abrisse/finary.git', branch: 'main'
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

### Overview

This gem provides one class to interact with a CRUD set of routes (like `users/generic_assets`).

Generally each class has 5 methods:

| Method   |      Description      |
|----------|:-------------:|
| `.all` |  retrieve all the items |
| `.get(:id)` |  get a specific item |
| `.create(params)` |  create a new item |
| `#update(:id, params)` |  updates the item |
| `#delete` |  deletes the item |

### User > Views

```ruby
# Get the dashboard view, net amounts on the last month
Finary::User::Views.dashboard(type: 'net', period: '1m')

# Get the portfolio view on the last week
Finary::User::Views.portfolio(period: '1w')
```

### User > Cryptos

```ruby
# Retrieve all the cryptos
cryptos = Finary::User::Crypto.all

# Get a specific crypto
Finary::User::Crypto.get(42)

# List the attributes
securities[0].attributes.keys

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

# Create a new crypto
crypto = Finary::User::Crypto.add(
  quantity: 100, 
  buying_price: 10,
  correlation_id: '61a8d7bd2c1653d2c4808e8a',
  holdings_account: {
    id: 'edd89abd-48a7-426e-9626-c6bb52063de0'
  }
)

# Update the crypto
updated_crypto = crypto.update(quantity: 110, buying_price: 11)

# Delete the crypto
updated_crypto.delete
```

### User > Generic Assets

```ruby
# Retrieve all the generic assets
assets = Finary::User::GenericAsset.all

# Get a specific generic asset
Finary::User::GenericAsset.get(42)

# List the attributes
securities[0].attributes.keys

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

# Create a new generic asset
asset = Finary::User::GenericAsset.add(
  buying_price: 1000,
  category: 'real_estate_crowdfunding',
  current_price: 1000,
  name: 'Anaxago - Projet X',
  quantity: 2
)

# Update the generic asset
updated_asset = asset.update(current_price: 1200, name: 'Anaxago > Projet X')

# Delete the generic asset
updated_asset.delete
```

### User > Holding Accounts

```ruby
# Retrieve all the holding accounts
accounts = Finary::User::Account.all

# List the attributes
securities[0].attributes.keys

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
```

### User > Loans

```ruby
# Retrieve all the loans
loans = Finary::User::Loan.all

# List the attributes
securities[0].attributes.keys

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
```

### User > Securities

```ruby
# Retrieve all the securities
securities = Finary::User::Security.all

# List the attributes
securities[0].attributes.keys

# [:id,
#  :security,
#  :quantity,
#  :current_value,
#  :unrealized_pnl,
#  :unrealized_pnl_percent,
#  :buying_price,
#  :account]
```

### HTTP Client

The `Finary::Client` allows to request the Finary API routes directly
and returns the parsed JSON body.

```ruby
client = Finary.client

client.get_user_generic_assets
client.get_user_holdings_accounts
client.get_user_securities
client.get_user_cryptos
client.get_user_loans
client.get_user_view(:dashboard, type: 'finary', period: '1w')
# ...
````

### External Providers import

This gem allows the user to synchronize his Finary account with an external provider.

Currently supported providers:

| Provider   |      Sync Type      |
|----------|:-------------:|
| [Anaxago](https://www.anaxago.com/) |  CSV |

### Axanago

The Anaxago Provider allows to automatically sync your Anaxago investments with your Finary Account.

Each waiting & ongoing Anaxago investment will be synchonized with a dedicated `Generic Asset` on Finary side:

* new investments are created
* ongoing investments are updated (notably the current price)
* finished invesments are removed

To run a sync, you need to download your Anaxago table investments as CSV file using [this link](https://app.anaxago.com/investments/table)
(click on the upper button `Télécharger`)

```ruby
Finary::Providers::Anaxago.new('Portefeuille Anaxago 01-01-2022.csv').sync
```

## Development

After checking out the repo, run `bundle install --path .bundle` to install dependencies. Then, run `rake spec` to run the tests.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/abrisse/finary. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
