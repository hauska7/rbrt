class Rbrt::State
  def self.build_new
    new(destroyed: false, new_record: true)
  end

  def self.build_existing
    new(destroyed: false, new_record: false)
  end

  def self.copy(state:)
    new(destroyed: state.destroyed, new_record: state.new_record)
  end

  def initialize(destroyed:, new_record:)
    @destroyed = destroyed
    @new_record = new_record
  end

  attr_reader :destroyed, :new_record

  def new_record?
    @new_record
  end

  def new_record
    @new_record = true
    self
  end

  def existing?
    existing_record?
  end

  def existing
    existing_record
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
