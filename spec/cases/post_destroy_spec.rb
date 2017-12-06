require "my_spec_helper"
require "./app/domain/comment"
require "./app/domain/post"
require "./app/cases/post_destroy"
require "./lib/rbrt/db_objects_in_memory"
require "./spec/doubles/persistance_double"
require "./spec/doubles/queries_double"

RSpec.describe PostDestroy do
  it "success" do
    persistance = PersistanceDouble.build
    comments = [Comment.build.set_db_id(persistance.sequence_db_id_next_comment),
                Comment.build.set_db_id(persistance.sequence_db_id_next_comment),
                Comment.build.set_db_id(persistance.sequence_db_id_next_comment),
                Comment.build.set_db_id(persistance.sequence_db_id_next_comment)]
    post = Post.build.set_db_id(persistance.sequence_db_id_next_post)
    queries = QueriesDouble
              .new(db_objects_in_memory: DBObjectsInMemory.build)
              .set_comments_with_post_where_post(comments: comments, associated_posts: [post] * comments.size)

    result = PostDestroy.call(persistance: persistance, queries: queries, post: post)

    expect(persistance.destroyed_comment_count).to eq 4
    expect(persistance.destroyed_post_count).to eq 1
  end
end
