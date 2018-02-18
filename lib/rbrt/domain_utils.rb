module Rbrt::DomainUtils
  def to_ary
    [self]
  end

  def slice(*args)
    args.map do |key|
      [key, send(key)]
    end
      .to_h
  end
end
