# TODO: move flags to hash
class Rbrt::AssociationState
  def initialize
    @flags = {}
  end

  def unset_all
    set(all: false)
    self
  end

  # tODO: move just for has one
  def all?
    is?(:all)
  end

  def set_all
    set(all: true)
    self
  end

  def assert_all
    assert(:all)
    self
  end

  def set_loaded
    set(loaded: true)
    self
  end

  def unset_loaded
    set(loaded: false)
    self
  end

  # tODO: move just for has one
  def loaded?
    is?(:loaded)
  end

  def assert_loaded
    assert(:loaded)
    self
  end
  
  private

  def is?(flag)
    @flags.fetch(flag, false)
  end

  def assert(*flags)
    fail "flag not set: #{flags}" unless flags.all? { |f| @flags.key?(f) }
    # TODO: implement easyhash
    fail "Wrong association state" unless @flags.select { |key, _value| flags.include?(key) }.values.all?
    self
  end

  def set(flags)
    @flags = @flags.merge(flags)
    self
  end
end
