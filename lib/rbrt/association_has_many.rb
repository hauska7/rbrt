class Rbrt::AssociationHasMany
  def self.build(name:, type:, elements:)
    fail unless type.has_many? && type.remember_destroyed?

    new(name: name, type: type, active: elements.active, destroyed: elements.destroyed)
  end


  def initialize(name:, type:, active:, destroyed:)
    @name = name
    @type = type
    @active = active
    @destroyed = destroyed
  end

  attr_reader :active, :destroyed, :name, :type

  def get
    @active
  end

  def unassociate(domain:)
    if domain.respond_to?(:each)
      common = domain - @active
      @active.remove(domain: common)
      @destroyed.add(common)
    else
      if @active.include?(domain)
        @active.remove(domain: domain)
        @destroyed.add(domain)
      end
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

  def forget_destroyed(domain:)
    @destroyed.delete(domain)
    self
  end

  def forget_active(domain:)
    @active.delete(domain)
    self
  end
end
