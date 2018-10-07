class Rbrt::AssociationsElements
  def initialize(active:, destroyed:)
    @active = active
    @destroyed = destroyed
  end

  def active
    @active.build
  end

  def destroyed
    @destroyed.build
  end
end
