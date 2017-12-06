class AttributesShell
  def shell?
    true
  end

  def fetch(*_args, &block)
    block&.call
  end
end
