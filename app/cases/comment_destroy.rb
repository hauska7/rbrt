class CommentDestroy
  class Result
    def initialize(comment_destroy)
      @comment = comment_destroy.comment
    end

    attr_reader :comment
  end

  def self.call(*args)
    new(*args).call
  end

  def initialize(persistance:, comment:)
    @persistance = persistance
    @comment = comment.tap { |comment| @persistance.add(comment) }
  end

  def destroy_comment
    @comment.state.destroy
    self
  end

  def call
    destroy_comment
    @persistance.persist
    Result.new(self)
  end

  attr_reader :comment
end
