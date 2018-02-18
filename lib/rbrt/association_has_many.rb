require "rbrt/association_store"
require "rbrt/association_store_single"
require "rbrt/association_has_many_state"

class Rbrt::AssociationHasMany
  def self.build_has_many(base:, name:)
    new(base: base, name: name)
  end

  def self.build_has_one(base:, name:)
    new(base: base, name: name, store_active: Rbrt::AssociationStoreSingle.build).tap { |a| a.state.unset_loaded }
  end

  # TODO: state for has one
  def initialize(base:, name:, store_active: Rbrt::AssociationStore.build)
    @base = base
    @name = name
    @state = Rbrt::AssociationHasManyState.new
    @active = store_active
    @removed = Rbrt::AssociationStore.build
  end

  attr_reader :base, :active, :removed

  def null?
    false
  end

  def active?
    !@active.empty?
  end

  def id
    [@name, @base]
  end

  def ==(other)
    other.id == id
  end

  def state
    @state
  end

  def get
    @active.base
  end

  def unassociate!(*associations)
    x = @active.remove(*associations)
    @removed.add(*x.removed)
    self
  end

  def unassociate(*associations)
    unassociate!(*associations)
    associations.map(&:unassociate!.with(self))
    self
  end

  # TODO: unassociate block
  def unassociate_self
    @active.unassociate!(self)
    unassociate!(*@active.to_a)
    self
  end

  def associate!(*associations)
    @active.add(*associations)
    self
  end

  # TODO: move implementation to Association
  def associate(*associations)
    associate!(*associations)
    associations.map(&:associate!.with(self))
    self
  end

  def clear_memory
    @removed.clear
    self
  end
end
