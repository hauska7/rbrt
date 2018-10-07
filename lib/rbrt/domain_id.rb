module Rbrt::DomainID
  attr_reader :id

  def set_id(id)
    @id = id
    self
  end

  def ==(other)
    other.id == id
  end
end
