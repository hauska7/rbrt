class Rbrt::AssociationHasManyJustActive
  def self.build(name:, type:, elements:)
    fail unless type.has_many? && type.just_active?

    new(name: name, type: type, active: elements.active)
  end

  def initialize(name:, type:, active:)
    @name = name
    @type = type
    @active = active
  end

  attr_reader :name, :type, :active

  def get
    @active
  end

  def unassociate(domain:)
    if domain.respond_to?(:each)
      @active.subtract(domain)
    else
      @active.delete(domain)
    end
    self
  end

  # TODO: unassociate block
  #def unassociate_self
  #  @active.unassociate!(self)
  #  unassociate!(*@active.to_a)
  #  self
  #end

  def associate(domain:)
    @active.add(domain)
    self
  end
end
