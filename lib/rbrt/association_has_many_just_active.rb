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
    @active.remove(domain: domain)
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
