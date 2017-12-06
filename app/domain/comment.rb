require "./lib/rbrt/attributes"
require "./lib/rbrt/prototype_rbrt"

module Comment
  def self.attributes
    [:content]
  end

  def self.prototype
    PrototypeRBRT.build
  end

  def self.build_base
    prototype
      .build_has_one(name: :post)
      .set_id
      .extend(self)
  end

  def self.build(attributes: Attributes.build(content: ""))
    build_base
      .set_attributes(attributes)
  end

  # TODO: fail if not nil ?
  def set_db_id(db_id)
    @db_id = db_id
    self
  end

  def db_id
    @db_id
  end

  def type
    :comment
  end
  
  # TODO: prettify !x.nil? pattern,  nil? -> null? ?
  # TODO: errors.add(key, :message_id) rails style
  def validate_create
    errors = validate
    errors[:post] = :missing if !post.loaded? || post.nil?
    errors
  end

  private def validate
    errors = {}
    errors[:content] = :too_short unless content.size > 1
    errors
  end

  # TODO: move to state module
  def destroy
    state.destroy
    self
  end
end
