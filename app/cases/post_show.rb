require "./lib/rbrt/associations"

class PostShow
  class Result
    def initialize(post_show)
      @post = post_show.post
      @comments = post_show.post.comments
    end

    attr_reader :post, :comments
  end

  def self.call(*args)
    new(*args).call
  end

  def initialize(post:, queries:)
    @post = post
    @queries = queries
  end

  def call
    @queries.comments_with_post_where_post(post: @post)
    Result.new(self)
  end

  attr_reader :post
end
