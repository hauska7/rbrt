class Rbrt::AssociationHasOneState
  def initialize
    @destroyed = false
  end

  def destroy
    @destroyed = true
    self
  end

  def destroyed?
    @destroyed
  end

  def visible?
    !@destroyed
  end

  def set_assert(flag)
    fail "unsupported flag"
  end
end
