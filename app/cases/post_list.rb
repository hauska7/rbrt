class PostList
  class Result
    def initialize(post_list)
      @posts = post_list.posts
    end

    attr_reader :posts
  end

  def self.call(*args)
    new(*args).call
  end

  def initialize(queries:)
    @queries = queries
  end

  def call
    @posts = @queries.post_all
    Result.new(self)
  end

  attr_reader :posts
end
