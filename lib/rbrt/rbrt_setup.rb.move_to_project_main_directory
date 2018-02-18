# Monkey patches for ruby

# https://stackoverflow.com/a/23711606/1167937
class Symbol
  def with(*args, &block)
    ->(caller, *rest) { caller.send(self, *rest, *args, &block) }
  end
end

class Object
  def yield_self
    yield(self)
  end
end

# nil.null? => true

class Hash
  def map_keys(mappings)
    map {|k, v| [mappings[k] || k, v] }.to_h
  end
end
