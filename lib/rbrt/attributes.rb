class Rbrt::Attributes
  def self.build(hash = {})
    new(hash)
  end

  def initialize(hash)
    @hash = hash
  end

  def method_missing(method_name, *args, &block)
    @hash.fetch(method_name) { super }
  end

  def shell?
    false
  end

  # TODO: fix hash interface eg for initializing active record, and more direct ==
  def to_hash
    @hash
  end

  def set(new_attributes)
    @hash.merge!(new_attributes.select { |attribute, _value| @hash.keys.include?(attribute) })
    self
  end

  def fetch(*args, &block)
    @hash.fetch(*args, &block)
  end

  def slice(*args)
    @hash.slice(*args)
  end

  private_class_method :new
end
