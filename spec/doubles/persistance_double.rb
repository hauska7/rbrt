require "./app/rbrt/memory_store"

class PersistanceDouble
  def self.build
    new
  end

  def initialize
    @persist_counter = 0
    @persisted_post_count = 0
    @persisted_comment_count = 0
    @store = MemoryStore.build
  end

  attr_reader :persist_counter,
              :persisted_post_count,
              :persisted_comment_count,
              :destroyed_post_count,
              :destroyed_comment_count

  def add(*objects)
    @store.add(*objects)
    self
  end

  def persist
    @persist_counter += 1
    @destroyed_post_count = @store
                            .posts
                            .select { |post| post.state.destroyed? }
                            .size
    @persisted_post_count = @store
                            .posts
                            .select { |post| !post.state.destroyed? }
                            .each { |post| persist_post(post) }
                            .size
    @destroyed_comment_count = @store
                               .comments
                               .select { |comment| comment.state.destroyed? }
                               .size
    @persisted_comment_count = @store
                               .comments
                               .select { |comment| !comment.state.destroyed? }
                               .each { |comment| persist_comment(comment) }
                               .size
    @store.clear
    self
  end

  def persist_post(post)
    if post.db_id.nil?
      post.set_db_id(sequence_db_id_next_post)
    else
      post
    end
  end

  def persist_comment(comment)
    if comment.db_id.nil?
      comment.set_db_id(sequence_db_id_next_comment)
    else
      comment
    end
  end

  def sequence_db_id_next_post
    @sequence_db_id_next_post ||= 0
    @sequence_db_id_next_post += 1
  end

  def sequence_db_id_next_comment
    @sequence_db_id_next_comment ||= 0
    @sequence_db_id_next_comment += 1
  end
end
