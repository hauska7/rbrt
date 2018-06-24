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
require "./app/cases/case"

class CreateGame < Case
  def self.call(*args)
    new(*args).call
  end

  def initialize(
    queries:,
    persistance:,
    current_user:,
    form:,
    domain_factory:,
    object_factory:
  )
    @persistance = persistance
    @queries = queries
    @current_user = current_user
    @form = form
    @domain_factory = domain_factory
    @object_factory = object_factory
  end

  def call
    guard_errors { @form.validate.errors }
    guard_errors { @current_user.authorize_case(self, object_factory: @object_factory).errors }

    group_query = @queries.many_group_with_owner_and_group_with_rank_where_rank_ids(rank_ids: @form.rank_db_ids)
    groups = group_query.groups

    game = @domain_factory.build_new_game
    game.get_object_factory(@object_factory)

    game_validator = game.object_factory.validator
    guard_errors { game_validator.assign_user_input(@form.attributes).errors }

    game_manager = game.object_factory.manager(current_user: @current_user, domain_factory: @domain_factory)
    guard_errors { game_manager.set_judge(@current_user).errors }
    guard_errors do
      game_manager.join_open_groups(*groups.select(&:open?)).errors
    end 
    guard_errors do
      game_manager.join_closed_groups(*groups.select(&:closed?)).errors
    end 

    guard_errors { game_validator.create.errors }
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
