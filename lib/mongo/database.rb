module Mongo
  class Database
    @@collections = {}

    def initialize(database, name, options = {})

    end

    def [](collection_name, options = {})
      Collection.new(nil, collection_name, options)
    end
  end
end
