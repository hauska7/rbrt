require "my_spec_helper"
require "./app/cases/post_show"
require "./app/domain/post"
require "./app/domain/comment"
require "./spec/doubles/queries_double"
require "./lib/rbrt/db_objects_in_memory"

RSpec.describe PostShow do
  it "" do
    comments = [Comment.build.set_db_id(1),
                Comment.build.set_db_id(2),
                Comment.build.set_db_id(3),
                Comment.build.set_db_id(4)]
    post = Post.build.set_db_id(1)
    queries = QueriesDouble
              .new(db_objects_in_memory: DBObjectsInMemory.build)
              .set_comments_with_post_where_post(comments: comments, associated_posts: [post] * comments.size)

    result = PostShow.call(post: post, queries: queries)

    expect(result.post).to be post
    expect(result.comments).to match_array comments
  end
end
