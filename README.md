# Rbrt

## Descriprion

This is a business logic framework for ruby. It is meant as help for keeping tract of what is the state of domain objects and associations in memory. When time comes you can add domain objects to persistance object which will generate proper SQL writes.

Business logic can depend on query methods for DB reads

  `queries.post_with_comments(post_id: post_id))`
  
And persistance object for DB writes.

  `persistance.add(post)`

  `persistance.add(comments)`

  `persistance.persist`
  
Checkout example app: https://github.com/hauska7/hacker_news_rbrt

## Use case example

```ruby
require "./app/cases/case"

class CreateGame < Case
  def self.call(*args)
    new(*args).call
  end

  def initialize(
    queries:,
    persistance:,
    authorize:,
    current_user:,
    form:,
    domain_factory:
  )
    @persistance = persistance
    @queries = queries
    @current_user = current_user
    @form = form
    @authorize = authorize
    @domain_factory = domain_factory
  end

  def call
    guard_errors { @form.validate }
    guard_errors { @current_user.ban_errors(self) }
    guard_errors { @authorize.create_game_errors(@current_user) }

    group_query = @queries.group_with_owner_where_group_id(group_id: @form.group_db_id)
    group = group_query.group
    guard_errors do
      group
      .manager
      .can_add_game_errors(@current_user)
    end

    game = @domain_factory.build_game
    game.attributes.set(@form.attributes)
    game.a.judge.associate(@current_user.a.judged_games).state.set_loaded
    game.a.group.associate(group.a.games).state.set_loaded

    guard_errors { @game.validate_create_errors }
    guard_errors { @persistance.persist.errors }
    success(game: game)
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
