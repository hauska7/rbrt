module Rbrt::Association
# TODO: build(type:)
  def self.build(type:, **args)
    if type.has_many? && type.just_active?
      Rbrt::AssociationHasMany.build(**args)
    elsif type.has_many? && type.remember_destroyed?
      Rbrt::AssociationHasManyRememberDestroyed.build(**args)
    elsif type.has_one? && type.full? && type.just_active?
      Rbrt::AssociationHasOne.build_full(**args)
    elsif type.has_one? && type.full? && type.remember_destroyed?
      Rbrt::AssociationHasOneRememberDestroyed.build_full(**args)
    elsif type.has_one? && type.empty? && type.just_active?
      Rbrt::AssociationHasOne.build_empty(**args)
    elsif type.has_one? && type.empty? && type.remember_destroyed?
      Rbrt::AssociationHasOneRememberDestroyed.build_empty(**args)
    else fail
    end
  end

  def self.change_worlds(association:, objects:)
    type = association.type
    if type.has_many? && type.remember_destroyed?
      active = association.active
      this_world_active = active.map { |domain| objects.find(domain: domain) }.compact
      #TODO: queries.get_from_this_world(domain: active)
      active.clear.add(this_world_active)

      destroyed = association.destroyed
      this_world_destroyed = destroyed.map { |domain| objects.find(domain: domain) }.compact
      destroyed.clear.add(this_world_destroyed)
    elsif type.has_one? && type.full? && type.remember_destroyed?
      this_world_active = objects.find(domain: association.active)
      if this_world_active
        association.set_active(this_world_active)
      else
        association.forget_active
      end

      destroyed = association.destroyed
      this_world_destroyed = destroyed.map { |domain| objects.find(domain: domain) }.compact
      destroyed.clear.add(this_world_destroyed)
    elsif type.has_one? && type.empty? && type.remember_destroyed?
      destroyed = association.destroyed
      this_world_destroyed = destroyed.map { |domain| objects.find(domain: domain) }.compact
      destroyed.clear.add(this_world_destroyed)
    elsif type.has_many? && type.just_active?
      active = association.active
      this_world_active = active.map { |domain| objects.find(domain: domain) }.compact
      active.clear.add(this_world_active)
    elsif type.has_one? && type.full? && type.just_active?
      this_world_active = objects.find(domain: association.active)
      if this_world_active
        association.set_active(this_world_active)
      else
        association.unassociate
      end
    elsif type.has_one? && type.empty? && type.just_active?
    else fail
    end
  end

  def self.copy(association:, association_elements:)
    type = association.type

    new_association = build(type: type, name: association.name, elements: association_elements)
    new_association.associate(domain: association.active) unless type.empty?
    new_association

    if type.remember_destroyed?
      new_association.destroyed.add(association.destroyed)
    end
    new_association
  end

  def self.copy_active(association:, association_elements:)
    just_active_type = Types.get(type: association.type, add_tag: :just_active)

    new_association = build(type: just_active_type, name: association.name, elements: association_elements)
    new_association.associate(domain: association.active) unless type.empty?
    new_association
  end

  # TODO: revise this logic
  def self.merge(association:, other_association:)
    type = association.type
    other_type = other_association.type
    #fail "Association type mismatch" unless type == other_type
    # type.just_active?
    # other_type.remember_destroyed?
    # type and other_type match at has_one? has_many?
      if other_type.empty?
        if type.just_active?
          if other_type.just_active?
          elsif other_type.remember_destroyed?
            association.unassociate(domain: other_association.destroyed)
          else fail
          end
        elsif type.remember_destroyed?
          if other_type.just_active?
          elsif other_type.remember_destroyed?
            association.unassociate(domain: other_association.destroyed)
          else fail
          end
        else fail
        end
      elsif type.just_active?
        if other_type.just_active?
          association.associate(domain: other_association.get)
        elsif other_type.remember_destroyed?
          association.associate(domain: other_association.get)
          association.unassociate(domain: other_association.destroyed)
        else fail
        end
      elsif type.remember_destroyed?
        if other_type.just_active?
          association.associate(domain: other_association.get)
        elsif other_type.remember_destroyed?
          association.associate(domain: other_association.get)
          association.unassociate(domain: other_association.destroyed)
        else fail
        end
      else fail
      end
      if other_type.full?
        association.associate(domain: other_association.get)
      elsif other_type.empty?
        association.unassociate
      else fail
      end
    else fail
    end
  end

  #def self.associate(association:, domain:, inverse_active_associations:, inverse_destroyed_associations:)
  #  type = association.type
  #  if type.has_many?
  #    if domain.respond_to?(:each)
  #      domain.each do |domain|
  #        domain.inverse_active_associations.add(domain: , association: association)
  #      end
  #    else
  #      domain.inverse_active_associations << association
  #    end
  #    association.associate(domain: domain)
  #  elsif type.has_one_full?
  #    association.active.inverse_destroyed_associations << association
  #    association.active.inverse_active_associations.delete(association)
  #    domain.inverse_active_associations << association

  #    association.associate(domain: domain)
  #  elsif type.has_one_empty?
  #    domain.inverse_active_associations << association
  #    association.associate(domain: domain)
  #  else fail
  #  end
  #  self
  #end

  #def self.unassociate(association:, domain:, inverse_active_associations:, inverse_destroyed_associations:)
  #  type = association.type
  #  if type.has_many?
  #    if domain.respond_to?(:each)
  #      domain.each do |domain|
  #        domain.inverse_destroyed_associations << association
  #        domain.inverse_active_associations.delete(association)
  #      end
  #    else
  #      domain.inverse_destroyed_associations << association
  #      domain.inverse_active_associations.delete(association)
  #    end

  #    association.associate(domain: domain)
  #  elsif type.has_one_full?
  #    association.active.inverse_destroyed_associations << association
  #    association.active.inverse_active_associations.delete(association)

  #    association.associate(domain: domain)
  #  else fail
  #  end
  #  self
  #end
end
