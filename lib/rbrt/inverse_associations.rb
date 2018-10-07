class Rbrt::InverseAssociations
  def add(domain:, association:)
    @store[domain] << association
  end

  def get(domain:)
    @store.fetch(domain)
  end
end
