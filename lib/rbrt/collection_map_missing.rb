#module Rbrt::CollectionMapMissing
#  # TODO: respond_to_missing
#  # TODO: extend MapMissing
#  def method_missing(method_name, *args, &block)
#    map(&:send.with(method_name, *args, &block))
#  end
#end

#class CollectionElements
#  def initialize(collection:)
#    @collection = collection
#  end
#
#  attr_reader :collection
#
#  def method_missing(method_name, *args, &block)
#    @collection.map(&:send.with(method_name, *args, &block))
#  end
#end
