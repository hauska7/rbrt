class Rbrt::Attributes
  def self.build(whitelist: nil, content: {})
    whitelist = content.keys if whitelist.nil?
    new(whitelist: whitelist, content: content)
  end

  def initialize(whitelist:, content:)
    @whitelist = whitelist
    @content = {}
    set_content(content)
  end

  def method_missing(method_name, *args, &block)
    @content.fetch(method_name) { super }
  end

  # TODO: this is not really used in app maybe worth removing for now
  def shell?
    false
  end

  # TODO: fix hash interface eg for initializing active record, and more direct ==
  def to_hash
    @content
  end

  def set_content(content)
    @content.merge!(content.select { |attribute, _value| @content.keys.include?(attribute) })
    self
  end

  def fetch(*args, &block)
    @content.fetch(*args, &block)
  end

  def slice(*args)
    @content.slice(*args)
  end

  private_class_method :new
end
