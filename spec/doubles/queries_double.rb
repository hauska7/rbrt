require "./lib/rbrt/associations"

# A query should in order:
# - fetch data from data source, usually eighter all attributes per object or just an id
# - build objects from data
# - check if any fetched objects are already used in application
# - associate most recent versions of objects
# - provide access to query result and if nessesary:
# -- all found recent objects eg. to add to persistance
# -- out of date objects

class QueriesDouble
  def initialize(db_objects_in_memory:)
    @db_objects_in_memory = db_objects_in_memory
  end
  
  # query START
  class CommentsWithPostWherePostQueryResult
    def initialize(comments:)
      @comments = comments
    end

    def comments
      @comments
    end

    def all_objects
      @comments + @comments.map(&:post)
    end
  end

  def comments_with_post_where_post(post:)
    associations = Associations.build(comment: [:post, :comments])
    cached_recent_comments_with_post = recent_comments_with_post(fetch_comments_with_post)
    associations.associate(*cached_recent_comments_with_post)
    CommentsWithPostWherePostQueryResult.new(comments: cached_recent_comments_with_post.map(&:comment))
  end

  def set_comments_with_post_where_post(comments:, associated_posts:)
    @comments = comments
    @associated_posts = associated_posts
    self
  end

  private def recent_comments_with_post(comments_with_post)
    comments_with_post.map do |comment_with_post|
      comment_with_post.comment = @db_objects_in_memory.get(comment_with_post.comment).recent
      comment_with_post.post = @db_objects_in_memory.get(comment_with_post.post).recent
      comment_with_post
    end
  end

  private def fetch_comments_with_post
    (@comments.zip(@associated_posts)).map do |comment_with_post|
      Struct.new(:comment, :post).new(comment_with_post[0], comment_with_post[1])
    end
  end
  # END


  # query START
  def set_post_all(posts:)
    @posts = posts
    self
  end

  def post_all
    @posts  
  end
  # END
end
