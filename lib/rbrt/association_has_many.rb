class AssociationHasMany < SimpleDelegator
  def self.build(base:, name:)
    new(base: base, name: name)
  end

  # TODO: DI for other associations store eg set, array
  def initialize(base:, name:)
    @base = base
    @name = name
    # TODO: use regular set and give it assiciations to compare for uniquness
    @other_associations = [].tap do |set|
      def set.merge(*associations_to_add)
        associations_to_add.each do |association_to_add|
          self << (association_to_add) unless self.any? { |existing_association| existing_association.association_id == association_to_add.association_id  }
        end
        self
      end
    end
  end

  attr_reader :base
  
  def association_id
    [@name, @base]
  end

  def get
    __getobj__ || fail("not associated")
  end
  
  def associate!(*other_associations)
    @other_associations.merge(*other_associations)
    set_other_association_bases
    self
  end

  def set_other_association_bases
    __setobj__(@other_associations.map(&:base))
  end

  # TODO: move implementation to Association
  def associate(*other_associations)
    associate!(*other_associations)
    # TODO: nice map(&:associate, self)
    other_associations.map { |oa| oa.associate!(self) }
    @base
  end
end
