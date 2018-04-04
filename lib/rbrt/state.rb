class Rbrt::State
  def self.build_new
    new(destroyed: false, new_record: true)
  end

  def self.build_existing
    new(destroyed: false, new_record: false)
  end

  def intialize(destroyed:, new_record:)
    @destroyed = destroyed
    @new_record = new_record
  end

  def new_record?
    @new_record
  end

  def new_record
    @new_record = true
    self
  end

  def existing_record?
    !@new_record
  end
  
  def existing_record
    @new_record = false
    self
  end
  
  def destroyed?
    @destroyed
  end

  def destroy
    @destroyed = true
    self
  end
end
