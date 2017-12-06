# Monkey patches for ruby

# https://stackoverflow.com/a/23711606/1167937
class Symbol
  def with(*args, &block)
    ->(caller, *rest) { caller.send(self, *rest, *args, &block) }
  end
end
