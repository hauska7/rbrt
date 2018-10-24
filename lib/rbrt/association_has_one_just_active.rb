class Rbrt::AssociationHasOneJustActive
  def self.build(name:, type:, elements:, types:)
    fail unless type.has_one? && type.just_active?

    active =
      if type.empty?
        nil
      elsif type.full?
        elements.active
      else fail
      end

    new(name: name, type: type, active: active, types: types)
  end

  # TODO: state for has one
  def initialize(name:, type:, active:, types:)
    @name = name
    @type = type
    @active = active
    @types = types
  end

  attr_reader :active, :type, :name

  def set_active(active)
    @active = active
    self
  end

  # TODO: fail if in wrong state (unloaded)
  def get
    fail "Empty association" unless @type.full?

    @active
  end

  def unassociate
    fail "Empty association" unless @type.full?

    @active = nil
    @type = @types.get(type: @type, add_tag: :empty)
    self
  end

  # TODO: unassociate block
  #def unassociate_self
  #  @active.unassociate!(self)
  #  unassociate!(*@active.to_a)
  #  self
  #end

  def associate(domain:)
    if @type.full?
      @active = domain
    elsif @type.empty?
      @active = domain
      @type = @types.get(type: @type, add_tag: :full)
    else fail
    end
    self
  end
end
