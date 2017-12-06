class AssociationHasOne < SimpleDelegator
  def self.build(base:, name:)
    new(base: base, name: name)
  end

  def initialize(base:, name:)
    @base = base
    @name = name
    @other_association = nil
  end

  attr_reader :base

  def association_id
    [@name, @base]
  end

  def get
    __getobj__ || fail("not associated")
  end

  def loaded?
    !@other_association.nil?
  end

  def associate!(other_association)
    @other_association = other_association
    __setobj__(@other_association.base)
    self
  end

  def associate(other_association)
    associate!(other_association)
    other_association.associate!(self)
    @base
  end
end
