require "./lib/rbrt/association_has_one"
require "./lib/rbrt/association_has_many"
require "./lib/rbrt/db_objects_in_memory"
require "./lib/rbrt/state"

class PrototypeRBRT
  #split attributes, associations and state to separate modules. low priority

  def self.build
    new
  end

  # tODO: DI
  def initialize(state: State.new)
    @state = state
    @attributes = {}
    @associations = {}
  end

  # tODO: set id only when initializing
  def set_id(id = object_id)
    @id = id
    self
  end

  def id
    @id
  end

  def state
    @state
  end

  def set_attributes(attributes)
    @attributes = attributes
    self
  end

  def revise_attributes(attributes)
    @attributes = attributes if @attributes.shell?
    self
  end

  def attributes
    @attributes
  end

  # TODO: super if definded? // to lose dependency on attributes and associations
  def method_missing(method_name, *args, &block)
    @attributes.fetch(method_name) do
      @associations.fetch(method_name) { super }
    end
  end

  # TODO: improve to match method_missing
  def respond_to_missing?(*_args)
    true
  end

  def build_has_one(name:)
    @associations[name] = AssociationHasOne.build(base: self, name: name)
    self
  end
  
  def build_has_many(name:)
    @associations[name] = AssociationHasMany.build(base: self, name: name)
    self
  end

  # never allow for nil id?
  def ==(other)
    return false if id.nil? || other.id.nil?
    other.id == id
  end
end
