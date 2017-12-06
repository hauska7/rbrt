require "my_spec_helper"
require "./app/cases/comment_create"
require "./app/domain/post"
require "./spec/doubles/persistance_double"

RSpec.describe CommentCreate do
  it 'success' do
    persistance = PersistanceDouble.build
    post = Post.build

    result = CommentCreate.call(persistance: persistance, post: post, attributes: { content: "I like batman more" })

    expect(result.comment.post.get).to be post
    expect(result.comment.content).to eq "I like batman more"
    expect(persistance.persisted_post_count).to eq 1
    expect(persistance.persisted_comment_count).to eq 1
  end

  it 'failure, no content' do
    persistance = PersistanceDouble.build
    post = Post.build

    result = CommentCreate.call(persistance: persistance, post: post, attributes: { content: "" })

    expect(result.errors.empty?).to be false
    expect(persistance.persist_counter).to eq 0
  end
end
