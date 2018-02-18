require "rbrt/associations"
require "rbrt/association_has_many"

module Rbrt::DomainAssociations
  def self.extended(domain_object)
    domain_object.set_associations(Rbrt::Associations.build)
  end

  def associations
    @associations
  end

  def a
    @associations
  end

  def set_associations(associations)
    @associations = associations
    self
  end

  # TODO: fix the mess with has_many used as has_one
  def build_has_one(name:)
    @associations[name] = Rbrt::AssociationHasMany.build_has_one(base: self, name: name)
    self
  end
  
  def build_has_many(name:)
    @associations[name] = Rbrt::AssociationHasMany.build_has_many(base: self, name: name)
    self
  end
end
