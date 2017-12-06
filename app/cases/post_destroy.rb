require "./app/validators/post_destroy_validator"

class PostDestroy
  class Result
    def initialize(post_destroy)
      @post = post_destroy.post
      @errors = post_destroy.errors
    end

    def success?
      @errors.empty?
    end

    attr_reader :post, :errors
  end

  def self.call(*args)
    new(*args).call
  end

  def initialize(post:, persistance:, queries:)
    @persistance = persistance
    @queries = queries
    @post = post
    @persistance.add(@post)
  end

  def call
    # mark associations as existing already in db
    # Associations.new(comments: :post) comments: [:post, :comments]
    @queries
      .comments_with_post_where_post(post: @post).tap { |query| @persistance.add(*query.all_objects) }
    # @post.comments.association.all_loaded
    @errors = validate
    if @errors.empty?
      destroy_post
      # detatch persisting from case, attatch after persisting tasks to persistance
      @persistance.persist
    end
    Result.new(self)
  end

  attr_reader :post, :errors

  private

  def validate
    PostDestroyValidator.validate(self)
  end

  def destroy_post
    # @comments.must_be_all.each... / @comments.all.each... / @comments.state.all.each...
    # @post.comments.state.destroy
    # @post.comments.destroy
    @post.comments.each(&:destroy)
    @post.destroy
    self
  end
end
