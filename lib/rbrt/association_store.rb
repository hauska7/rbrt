require "rbrt/collection_map_missing"

class Rbrt::AssociationStore
  def self.build
    new
  end

  def initialize
    @store = Set.new.extend(Rbrt::CollectionMapMissing)
  end

  def add(*associations)
    @store.merge(associations.select { |a| !a.null? })
    self
  end

  def remove(*associations)
    result = Struct.new(:store, :removed, :not_found).new(self, [], [])
    associations
      .each_with_object(result) do |association, result|
      if @store.delete(association)
        result.removed << association
      else
        result.not_found << association
      end
    end
  end

  def clear
    @store.clear
    self
  end

  # TODO: danger - rescuing some other method missing
  def method_missing(method_name, *args, &block)
    @store.send(method_name, *args, &block)
  rescue MethodMissing
    super
  end
end
