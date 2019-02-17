module Rbrt::Association
  def self.build(type:, types:, **args)
    if type.has_many? && type.just_active?
      Rbrt::AssociationHasManyJustActive.build(type: type, **args)
    elsif type.has_many? && type.remember_destroyed?
      Rbrt::AssociationHasMany.build(type: type, **args)
    elsif type.has_one? && type.full? && type.just_active?
      Rbrt::AssociationHasOneJustActive.build(type: type, types: types, **args)
    elsif type.has_one? && type.full? && type.remember_destroyed?
      Rbrt::AssociationHasOne.build(type: type, types: types, **args)
    elsif type.has_one? && type.empty? && type.just_active?
      Rbrt::AssociationHasOneJustActive.build(type: type, types: types, **args)
    elsif type.has_one? && type.empty? && type.remember_destroyed?
      Rbrt::AssociationHasOne.build(type: type, types: types, **args)
    else fail
    end
  end

  def self.change_worlds(association:, objects:, object_factory:)
    type = association.type
    if type.has_many? && type.remember_destroyed?
      active = association.active


      # TODO: build persistance object if not found


      this_world_active = active.map do |domain|
        object = objects.find { |o| o == domain }
        if object
          object
        else
          object = object_factory.build(domain: domain)
          objects << object
          object
        end
      end
      #TODO: queries.get_from_this_world(domain: active)
      active.clear.add(this_world_active)

      #destroyed = association.destroyed
      #this_world_destroyed = destroyed.map do |domain|
      #  object = objects.find { |o| o == domain }
      #  if object
      #    object
      #  else
      #    object = object_factory.build(domain: domain)
      #    objects << object
      #    object
      #  end
      #end
      #destroyed.clear.add(this_world_destroyed)
      destroyed.clear
    elsif type.has_one? && type.full? && type.remember_destroyed?
      this_world_active = objects.find { |domain| domain == association.active }
      unless this_world_active
        this_world_active = object_factory.build(domain: domain)
        objects << this_world_active
        this_world_active
      end

      association.set_active(this_world_active)

      #destroyed = association.destroyed
      #this_world_destroyed = destroyed.map do |domain|
      #  object = objects.find { |o| o == domain }
      #  if object
      #    object
      #  else
      #    object = object_factory.build(domain: domain)
      #    objects << object
      #    object
      #  end
      #end
      #destroyed.clear.add(this_world_destroyed)
      destroyed.clear
    elsif type.has_one? && type.empty? && type.remember_destroyed?
      #destroyed = association.destroyed
      #this_world_destroyed = destroyed.map do |domain|
      #  object = objects.find { |o| o == domain }
      #  if object
      #    object
      #  else
      #    object = object_factory.build(domain: domain)
      #    objects << object
      #    object
      #  end
      #end
      #destroyed.clear.add(this_world_destroyed)
      destroyed.clear
    elsif type.has_many? && type.just_active?
      active = association.active
      this_world_active = active.map do |domain|
        object = objects.find { |o| o == domain }
        if object
          object
        else
          object = object_factory.build(domain: domain)
          objects << object
          object
        end
      end
      active.clear.add(this_world_active)
    elsif type.has_one? && type.full? && type.just_active?
      this_world_active = objects.find { |o| o == association.active }
      unless this_world_active
        this_world_active = object_factory.build(domain: association.active)
        objects << this_world_active
        this_world_active
      end
      association.set_active(this_world_active)
    elsif type.has_one? && type.empty? && type.just_active?
    else fail
    end
  end

  def self.copy(types:, association:, association_elements:)
    type = association.type

    new_association = build(type: type, types: types, name: association.name, elements: association_elements)
    new_association.associate(domain: association.active) unless type.empty?
    new_association

    if type.remember_destroyed?
      new_association.destroyed.add(association.destroyed)
    end
    new_association
  end

  def self.copy_active(types:, association:, association_elements:)
    just_active_type = types.get(type: association.type, add_tag: :just_active)

    new_association = build(type: just_active_type, types: types, name: association.name, elements: association_elements)
    new_association.associate(domain: association.active) unless just_active_type.empty?
    new_association
  end

  # TODO: revise this logic
  def self.merge(association:, other_association:)
    type = association.type
    other_type = other_association.type
    fail "Association type mismatch" if type.has_one? != other_type.has_one?
    fail "Association type mismatch" if type.has_many? != other_type.has_many?
    has_one = type.has_one?
    # type.just_active?
    # other_type.remember_destroyed?
    # type and other_type match at has_one? has_many?
    unless has_one
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
    end

    if has_one
      if other_type.full?
        association.associate(domain: other_association.get)
      elsif other_type.empty?
        association.unassociate
      else fail
      end
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
