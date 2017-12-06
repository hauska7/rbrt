require "./lib/rbrt/prototype_rbrt"
require "./lib/rbrt/attributes"
require "./lib/rbrt/attributes_shell"

module Post
  def self.attributes
    [:title]
  end

  def self.attributes_create
    [:title]
  end

  def self.prototype
    PrototypeRBRT.build
  end

  def self.build_base
    prototype
      .build_has_many(name: :comments)
      .set_id
      .extend(self)
  end

  def self.build(attributes: Attributes.build(title: ""))
    build_base
      .set_attributes(attributes)
  end

  def self.build_shell
    build_base
      .set_attributes(AttributesShell.new(:title))
  end

  def set_db_id(db_id)
    @db_id = db_id
    self
  end

  def db_id
    @db_id
  end

  def type
    :post
  end

  def validate_create
    validate
  end

  private def validate
    errors = {}
    errors[:title] = :too_short unless title.size > 1
    errors
  end

  def destroy
    state.destroy
    self
  end
end
