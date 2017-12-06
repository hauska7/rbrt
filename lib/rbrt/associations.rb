class Associations
  def self.build(hash)
    new(hash)
  end

  def initialize(hash)
    @hash = hash
  end

  def associate(*many_associated_objects)
    many_associated_objects.each do |associated_objects|
      @hash.each do |key, value|
        associated_objects.send(key).send(value[0]).associate(associated_objects.send(value[0]).send(value[1]))
      end
    end
    self
  end
end
