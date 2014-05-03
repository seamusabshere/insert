# Insert

Super simple way to insert rows into a database

## Installation

Add this line to your application's Gemfile:

    gem 'insert'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install insert

## Usage

```ruby
insert = Insert.new pg_connection_object
insert.insert :dogs, name: 'jerry'
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/insert/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
