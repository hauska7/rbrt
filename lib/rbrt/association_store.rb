class Rbrt::AssociationStore
  def self.build(store: Set.new)
    new(store: store)
  end

  def self.copy(association_store:)
    store = Set.new(association_store.store)
    build(store: store)
  end

  def initialize(store:)
    @store = store
  end

  def clone
    self.class.copy(association_store: self)
  end

  attr_reader :store

  def each(*args, &block)
    @store.each(*args, &block)
  end

  def map(*args, &block)
    @store.map(*args, &block)
  end

  def select(*args, &block)
    @store.select(*args, &block)
  end

  def include?(*args, &block)
    @store.include?(*args, &block)
  end

  def add(domain)
    if domain.respond_to?(:each)
      domain.each do |domain|
        @store << domain
      end
    else
      @store << domain
    end
    self
  end

  def remove(domain:)
    if domain.respond_to?(:each)
      domain.each do |domain|
        @store.delete(domain)
      end
    else
      @store.delete(domain)
      self
    end
  end

  def clear
    @store.clear
    self
  end
end
