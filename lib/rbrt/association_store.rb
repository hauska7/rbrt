require "rbrt/collection_map_missing"

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

  attr_reader :store

  def each(*args, &block)
    @store.each(*args, &block)
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

  # TODO: danger - rescuing some other method missing
  #def method_missing(method_name, *args, &block)
  #  @store.send(method_name, *args, &block)
  #rescue MethodMissing
  #  super
  #end
end
