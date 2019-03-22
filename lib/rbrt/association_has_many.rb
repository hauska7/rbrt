class Rbrt::AssociationHasMany
  def self.build(name:, type:, elements:)
    fail unless type.has_many? && type.remember_destroyed?

    new(name: name, type: type, active: elements.active, destroyed: elements.destroyed)
  end

  def self.clone(association_has_many:)
    new(
      name: association_has_many.name,
      type: association_has_many.type,
      active: association_has_many.active.clone,
      destroyed: association_has_many.destroyed.clone
    )
  end

  def initialize(name:, type:, active:, destroyed:)
    @name = name
    @type = type
    @active = active
    @destroyed = destroyed
  end

  attr_reader :active, :destroyed, :name, :type

  def clone
    Rbrt::AssociationHasMany.clone(association_has_many: self)
  end

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

  def associate(domain:, relation: nil)
    # TODO: relation

    @destroyed.remove(domain: domain)
    @active.add(domain)
    self
  end

  def forget_destroyed(domain:)
    @destroyed.delete(domain)
    self
  end

  def forget_active
    @active.clear
    self
  end

  def replace_all(domain:)
    @active.map! do |active_object|
      domain.find { |domain_object| same?(domain_object, active_object) } || fail("must be found")
    end
  end

  def same?(object, other)
    object.id == other.id
  end
end
