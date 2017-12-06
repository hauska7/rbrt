class MemoryStore
  # TODO: build(parent_memory_store:) to free references easily
  def self.build
    new
  end

  def initialize
    @store = Set.new
  end

  def add(*objects)
    objects.each { |object| @store << object }
    self
  end

  def clear
    @store = Set.new
  end

  def posts
    @store.select { |object| object.type == :post }
  end

  def comments
    @store.select { |object| object.type == :comment }
  end
end
