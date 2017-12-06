module CommentCreateValidator
  def self.validate(comment_create)
    comment_create.comment.validate_create
  end
end
