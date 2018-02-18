module Rbrt::DomainID
  # tODO: set id only when initializing
  def set_id(id = object_id)
    @id = id
    self
  end

  def id
    @id
  end

  # TODO: what id should null object have?
  def ==(other)
    return false if null? || other.null?
    other.id == id
  end
end
