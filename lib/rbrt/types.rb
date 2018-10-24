class Rbrt::Type < SimpleDelegator
  def self.build(tag:)
    set =
      if tag.respond_to?(:each)
        Set.new(tag)
      else
        Set.new([tag])
      end
    
    new(set)
  end

  def tags
    __getobj__
  end

  def method_missing(method_name, *_args)
    tag = method_name.to_s[0..-2].to_sym
    __getobj__.include?(tag)
  end
end

class Rbrt::Types
  def initialize
    @types = []
  end

  def get(type: nil, add_tag: nil)
    tags = []
    tags.concat(type.tags) unless type.nil?

    if add_tag.respond_to?(:each)
      add_tag.each do |add_tag|
        if add_tag == :just_active
          tags.remove(:remember_destroyed)
        elsif add_tag == :remember_destroyed
          tags.delete(:just_active)
        elsif add_tag == :empty
          tags.delete(:full)
        elsif add_tag == :full
          tags.delete(:empty)
        end
      end
    else
      if add_tag == :just_active
        tags.delete(:remember_destroyed)
      elsif add_tag == :remember_destroyed
        tags.delete(:just_active)
      elsif add_tag == :empty
        tags.delete(:full)
      elsif add_tag == :full
        tags.delete(:empty)
      end
    end

    tags.concat(add_tag)

    tmp_type = Rbrt::Type.build(tag: tags)

    found_type = @types.find { |type| type == tmp_type }

    if found_type
      found_type
    else
      @types << tmp_type
      tmp_type
    end
  end
end
