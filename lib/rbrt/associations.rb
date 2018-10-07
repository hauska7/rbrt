class Rbrt::Associations
# TODO: build(type:)
  def self.build
  end

  def initialize
    @store = {}
  end

  def each(&block)
    @store.map(&:second).each(&block)
  end

  def fetch(*args, &block)
    @store.fetch(*args, &block)
  end

  def add(association)
    @store[association.name] = association
  end

  def forget_destroyed
    each do |association|
      association.destroyed.clear
    end
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

  def self.merge(associations:, other_associations:)
    other_associations.each do |other_association|
      association = associations.fetch(other_association.name) { Rbrt::Association.build(type: other_association.type) }
      Rbrt::Association.merge(association: association, other_association: other_association)
    end
    self
  end
end
