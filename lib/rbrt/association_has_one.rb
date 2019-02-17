require "rbrt/association_state"

class Rbrt::AssociationHasOne
  def self.build(name:, type:, elements:, types:)
    fail unless type.has_one? && type.remember_destroyed?

    active =
      if type.empty?
        nil
      elsif type.full?
        elements.active
      else fail
      end

    new(name: name, type: type, active: active, destroyed: elements.destroyed, types: types)
  end

  # TODO: state for has one
  def initialize(name:, type:, active:, destroyed:, types:)
    @name = name
    @type = type
    @active = active
    @destroyed = destroyed
    @types = types
  end

  attr_reader :active, :destroyed, :type, :name

  def set_active(active)
    @active = active
    self
  end

  # TODO: fail if in wrong state (unloaded)
  def get
    fail "Empty association" unless @type.full?

    @active
  end

  # TODO: consider moving associate/unassociate form this object
  # TODO: fail if in wrong state (unloaded)
  def unassociate(domain: nil)
    #fail "domain object not associated" if domain && domain != @active
    #fail "Empty association" unless @type.full?

    if @type.full?
      @destroyed.add(@active)
      @active = nil
      @type = @types.get(type: @type, add_tag: :empty)
    elsif @type.empty?
    else fail
    end
    self
  end

  # TODO: unassociate block
  #def unassociate_self
  #  @active.unassociate!(self)
  #  unassociate!(*@active.to_a)
  #  self
  #end

  # TODO: split logic by type and put it on parent in Simple delegator
  def associate(domain:)
    if @type.has_one? && @type.full?
      @destroyed.add(@active)
      @active = domain
    elsif @type.has_one? && @type.empty?
      @active = domain
      @type = @types.get(type: @type, add_tag: :full)
    else fail
    end
    self
  end

  def forget_destroyed(domain:)
    @destroyed.delete(domain)
    self
  end

  def forget_active
    fail unless @type.full?
    
    @active = nil
    @type = @types.get(type: @type, add_tag: :empty)
    self
  end

  def clear
    @destroyed.clear
    self
  end
end
