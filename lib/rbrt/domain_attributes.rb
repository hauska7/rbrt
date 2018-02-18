module Rbrt::DomainAttributes
  def self.extended(domain_object)
    domain_object.set_attributes({})
  end

  def set_attributes(attributes)
    @attributes = attributes
    self
  end

  def revise_attributes(attributes)
    @attributes = attributes if @attributes.shell?
    self
  end

  def attributes
    @attributes
  end
end
