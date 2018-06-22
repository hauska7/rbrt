class Rbrt::DBObjectsInMemory
  class Result
    def initialize(recent:)
      @recent = recent
    end
  
    attr_reader :recent
  end

  def self.build
    new
  end

  def initialize
    @type_db_id_store = {}
  end

  attr_reader :type_db_id_store

  def empty_copy
    self.class.build
  end

  def get(object, db_id: nil)
    db_id = db_id || object.db_id
    return Result.new(recent: object) if db_id.nil?
    type_and_db_id = [object.type, db_id]
    Result.new(recent: @type_db_id_store
                         .fetch(type_and_db_id) { object.tap { @type_db_id_store[type_and_db_id] = object } }
                         .tap(&:revise_attributes.with(object.attributes)))
  end
end
