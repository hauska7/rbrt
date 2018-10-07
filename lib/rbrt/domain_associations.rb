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
end
