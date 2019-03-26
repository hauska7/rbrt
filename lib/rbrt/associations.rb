class Rbrt::Associations
# TODO: build(type:)
  def self.build
    new({})
  end

  def self.build_from_hash(hash)
    new(hash.clone)
  end

  def self.clone(associations:)
    result = build
    associations.each do |association|
      result.add(association.clone)
    end
    result
  end

  def self.merge(associations:, other_associations:, types:, elements:)
    new_associations = []
    other_associations.each do |other_association|
      association = associations.fetch(other_association.name, nil)
      unless association
        association = Rbrt::Association.build(
          type: other_association.type,
          types: types,
          name: other_association.name,
          elements: elements
        )
        new_associations << association
      end
      Rbrt::Association.merge(association: association, other_association: other_association)
    end
    associations.add(new_associations)
    self
  end

  def initialize(store)
    @store = store
  end

  def clone
    self.class.clone(associations: self)
  end

  def merge(associations:, types:, elements:)
    self.class.merge(associations: self, other_associations: associations, types: types, elements: elements)
  end

  attr_reader :store

  def each(&block)
    @store.map(&:second).each(&block)
  end

  def fetch(*args, &block)
    @store.fetch(*args, &block)
  end

  def add(association)
    if association.respond_to?(:each)
      association.each do |association|
        @store[association.name] = association
      end
    else
      @store[association.name] = association
    end
    self
  end

  def forget_destroyed
    each do |association|
      association.destroyed.clear
    end
  end

  def has?(association_name)
    @store.key?(association_name.to_sym)
  end

  def replace_all(domain:)
    each { |association| association.replace_all(domain: domain) }
  end

  def method_missing(method_name, *args, &block)
    @store[method_name] || fail("no association #{method_name} in associations")
  end

  #def self.build
  #  {}.tap do |associations|
  #    def associations.loaded
  #      select { |_name, association| association.state.loaded? }.tap do |loaded_associations|
  #        def loaded_associations.names
  #          keys
  #        end
  #      end
  #    end
  #    def associations.names
  #      keys
  #    end
  #    def associations.all
  #      values
  #    end
  #    def associations.method_missing(method_name, *args, &block)
  #      self[method_name]
  #    end
  #  end
  #end
end
