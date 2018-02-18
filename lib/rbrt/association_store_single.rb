class Rbrt::AssociationStoreSingle < SimpleDelegator
  class Rbrt::AssociationNull
    def null?
      true
    end

    def base
      nil
    end

    def unassociate!(*_args)
      self
    end
  end

  def self.build
    new
  end

  def initialize
    super(Rbrt::AssociationNull.new)
  end

  # to use with ruby splat operator
  def to_a
    [__getobj__]
  end

  def add(association)
    __setobj__(association)
    self
  end

  def remove(association)
    result = Struct.new(:store, :removed, :not_found).new(self, [], [])
    if __getobj__ == association
      __setobj__(AssociationNull.new)
      result.removed << association
    else
      result.not_found << association
    end
    result
  end

  # TODO: this method shouldnt be nesesary
  def size
    if __getobj__.null?
      0
    else
      1
    end
  end

  def empty?
    __getobj__.null?
  end
end
