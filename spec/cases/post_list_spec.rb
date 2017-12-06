require "my_spec_helper"
require "./app/cases/post_list"
require "./app/domain/post"
require "./lib/rbrt/db_objects_in_memory"

RSpec.describe PostList do
  it "" do
    posts = [Post.build.set_db_id(1),
             Post.build.set_db_id(2),
             Post.build.set_db_id(3),
             Post.build.set_db_id(4)]
    queries = QueriesDouble.new(db_objects_in_memory: DBObjectsInMemory.build).set_post_all(posts: posts)

    result = PostList.call(queries: queries)

    expect(result.posts.to_a).to match_array posts
  end
end
