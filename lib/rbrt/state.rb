class State
  def initialize
    @destroyed = false
  end
  
  def destroyed?
    @destroyed
  end

  def destroy
    @destroyed = true
    self
  end
end
