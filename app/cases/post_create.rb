require "./app/domain/post"

class PostCreate
  class Result
    def initialize(post_create)
      @post = post_create.post
      @errors = post_create.errors
    end

    def success?
      @errors.empty?
    end

    attr_reader :post, :errors
  end

  def self.call(*args)
    new(*args).call
  end

  def initialize(persistance:, attributes:)
    @persistance = persistance
    @attributes = attributes
  end

  def call
    @post = build_post
    @errors = validate
    @persistance.persist if @errors.empty?
    Result.new(self)
  end

  attr_reader :post, :errors

  private

  def validate
    @post.validate_create
  end

  def build_post
    Post
      .build
      .set_attributes(@attributes)
      .tap { |post| @persistance.add(post) }
  end
end
