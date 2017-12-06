class DBObjectsInMemory
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

  def get(object)
    return Result.new(recent: object) if object.db_id.nil?
    type_and_db_id = [object.type, object.db_id]
    Result.new(recent: @type_db_id_store
                         .fetch(type_and_db_id) { object.tap { @type_db_id_store[type_and_db_id] = object } }
                         .tap(&:revise_attributes.with(object.attributes)))
  end
end
