# Rbrt

## Descriprion

This is a business logic framework for ruby. It allows for running tests without database. Some patterns used are Repository, Identity Map, Unit Of Work.

Business logic can depend on query methods for DB reads

  `queries.post_with_comments(post_id: post_id))`
  
And persistance object for DB writes.

  `persistance.persist`
  
Checkout example app: https://github.com/hauska7/hacker_news_rbrt

## Use case example

```ruby
require "./app/cases/use_case"

class CreateGame < UseCase
  def self.call(*args)
    new(*args).call
  end

  def initialize(
    queries:,
    persistance:,
    current_user:,
    form:,
    domain_factory:,
    object_factory:,
    types:
  )
    @persistance = persistance
    @queries = queries
    @current_user = current_user
    @form = form
    @domain_factory = domain_factory
    @object_factory = object_factory
    @types = types
  end

  def call
    @form.validate

    game = @domain_factory.build(type: @types.game)

    game_validator = @object_factory.validator.build(domain: game)
    game_validator.assign_user_input(@form.attributes)

    game_manager = @object_factory.manager.build(domain: game, current_user: @current_user, domain_factory: @domain_factory)
    game_manager.set_judge(@current_user)

    groups_query = @queries.full_groups(group_ids: @form.group_db_ids)
    groups = groups_query.groups

    open_groups = groups.select { |group| group.type.open? }
    closed_groups = groups.select { |group| group.type.closed? }
    game_manager.join_open_groups(*open_groups)
    game_manager.join_closed_groups(*closed_groups)

    game_validator.create

    @persistance.persist

    success(game: game)
  rescue UseCaseFailure => e
    failure(errors: e.errors)
  end
end                
```

## Warning

Rbrt is in early development phase and as such it is not viable for any time sensitive development. If you decided to use it for a project it is very much possible you would need at some point contribute to rbrt.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rbrt', git: 'https://github.com/hauska7/rbrt'
```

And then execute:

    $ bundle

And then copy file rbrt/lib/rbrt_setup.rb.move_to_project_main_directory to rbrt_setup.rb in your project main directory it needs to be required when running rbrt. For example when running rbrt from rspec without loading eg Rails it should be required in spec helper and in case you run rbrt in Rails application rbrt_setup.rb should be required in initializers.

   $ cp \`bundle show rbrt\`\lib\rbrt_setup.rb.move_to_project_main_directory rbrt_setup.rb

## Contributing

Bug reports and pull requests are welcome. Currently rspec tests for this gem are lacking as it is being tested through an application I am writing and this is a by product so keep that in mind. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Rbrt project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/hauska7/rbrt/blob/master/CODE_OF_CONDUCT.md).
