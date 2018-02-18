# Rbrt

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rbrt'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rbrt

## Usage

This is a collection of classes to help write business rules in ruby, mainly handling domain object associations like has_many, has_one and role. Program can then depend on query methods for DB reads(queries.post_with_comments(post_id: post_id)) and persistance object (persistance.add(post); persistance.add(comments); persistance.persist) for DB writes.
Checkout example app: TODO: example app url

## Contributing

Bug reports and pull requests are welcome. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Rbrt project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/hauska7/rbrt/blob/master/CODE_OF_CONDUCT.md).
