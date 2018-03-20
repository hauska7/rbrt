# Rbrt

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rbrt', git: 'https://github.com/hauska7/rbrt'
```

And then execute:

    $ bundle

And then copy file rbrt/lib/rbrt_setup.rb.move_to_project_main_directory to rbrt_setup.rb in your project main directory it needs to be required when running rbrt. For example when running rbrt from rspec without loading eg Rails it should be required in spec helper and in case you run rbrt in Rails application rbrt_setup.rb should be required in initializers.

   $ cp \`bundle show rbrt\`\lib\rbrt_setup.rb.move_to_project_main_directory rbrt_setup.rb

## Usage

Example use case:

```ruby
require "./app/domain/game"
require "./app/cases/cases"

class GameCreate
  def self.call(*args)
    new(*args).call
  end

  def initialize(queries:, persistance:, authorize:, current_user:, group_db_id:, attributes:)
    @persistance = persistance
    @queries = queries
    @current_user = current_user
    @group_db_id = group_db_id
    @attributes = attributes
    @authorize = authorize
  end

  def call
    @errors = @current_user.ban_errors(self)
    if @errors.empty?
      @errors = @authorize.game_create_errors(@current_user)
      if @errors.empty?
        group = @queries.group_with_owner_where_group_id(group_id: @group_db_id).group
        @errors = group.can_add_game_errors(@current_user)
        if @errors.empty?
          @game = Game.build
          @game.attributes.set(@attributes)
          @game.a.judge.associate(@current_user.a.judged_games).state.set_loaded
          @game.a.group.associate(group.a.games).state.set_loaded
          @errors = @game.validate_create_errors
          if @errors.empty?
            @persistance.add(@current_user, @game, group)
            @persistance.persist
          end
        end
      end
    end
    Struct
      .new(:case_name,   :type, :current_user, :persistance, :game, :page,          :success?,      :errors)
      .new(:game_create, type,  @current_user, @persistance, @game, @resolved_page, @errors.empty?, @errors).tap do |result|
      Cases.case_ran(result)
    end
  end

  def type
    :write
  end
end                
```

This is a collection of classes to help write business logic, mainly handling domain object associations like has_many, has_one and role. It will also keep state for new/destroyed objects/associations that can later be read by persistance object to generate proper SQL writes.

Program can depend on query methods for DB reads

  `queries.post_with_comments(post_id: post_id))`
  
And persistance object for DB writes.

  `persistance.add(post)`
  `persistance.add(comments)`
  `persistance.persist`
  
Checkout example app: https://github.com/hauska7/hacker_news_rbrt

## Contributing

Bug reports and pull requests are welcome. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Rbrt project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/hauska7/rbrt/blob/master/CODE_OF_CONDUCT.md).
