class Attributes
  def self.build(hash)
    new(hash)
  end

  def initialize(hash)
    @hash = hash
  end

  def shell?
    false
  end

  def set(**new_attributes)
    @hash.merge!(new_attributes.select { |attribute, _value| @hash.keys.include?(attribute) })
    self
  end

  def fetch(*args, &block)
    @hash.fetch(*args, &block)
  end

  private_class_method :new
end
