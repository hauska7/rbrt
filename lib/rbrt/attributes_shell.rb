class Rbrt::AttributesShell
  # TODO: remove shell? interface and add set!() method that will work also with shell?(instead of revise_attributes)
  def shell?
    true
  end

  def fetch(*_args, &block)
    block&.call
  end
end
