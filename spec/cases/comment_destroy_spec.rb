require "my_spec_helper"
require "./app/domain/comment"
require "./app/cases/comment_destroy"
require "./spec/doubles/persistance_double"

RSpec.describe CommentDestroy do
  it 'success' do
    persistance = PersistanceDouble.build
    comment = Comment.build.set_db_id(persistance.sequence_db_id_next_comment)

    result = CommentDestroy.call(persistance: persistance, comment: comment)

    expect(persistance.destroyed_comment_count).to eq 1
  end
end
