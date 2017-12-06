require "./app/validators/comment_create_validator"
require "./app/domain/comment"
require "./app/domain/post"

class CommentCreate
  class Result
    def initialize(comment_create)
      @comment = comment_create.comment
      @errors = comment_create.errors
    end

    def success?
      @errors.empty?
    end

    attr_reader :comment, :errors
  end

  def self.call(*args)
    new(*args).call
  end

  def initialize(persistance:, post:, attributes:)
    @persistance = persistance
    @post = post
    @attributes = attributes
    @persistance.add(@post)
  end

  def call
    @comment = build_comment_with_post
    @errors = validate
    @persistance.persist if @errors.empty?
    Result.new(self)
  end

  attr_reader :comment, :errors

  private

  def validate
    CommentCreateValidator.validate(self)
  end

  def build_comment_with_post
    Comment
      .build
      .tap { |comment| comment.attributes.set(@attributes) }
      .tap { |comment| @persistance.add(comment) }
      .post
      .associate(@post.comments)
  end
end
