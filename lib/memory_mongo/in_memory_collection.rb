# frozen_string_literal: true

module MongoRubyServer
  class InMemoryCollection
    extend Forwardable

    @@collections = {}

    def initialize(_database, name, _options = {})
      @@collections[name] = []
      @name = name
    end

    def inspect
      "#<Mongo::InMemoryCollection:0x#{object_id}"
    end

    def insert_one(document, _options = {})
      @@collections[@name] += [{ _id: BSON::ObjectId.new }.merge(document)]

      replies = nil
      server_description = nil
      connection_global_id = 0

      Mongo::Operation::Insert::Result.new(
        replies,
        server_description,
        connection_global_id,
        inserted_document_ids
      )
    end

    # TODO: Check what is the namespace in mongo
    def namespace
      'something'
    end

    # TODO: replace this later
    def inserted_document_ids
      [1]
    end

    def insert_many(documents, _options = {})
      stored_documents = documents.map.each do |doc|
        { _id: BSON::ObjectId.new }.merge(doc)
      end

      @@collections[@name] += stored_documents

      Mongo::BulkWrite::Result.new({
                                     'n_inserted' => documents.size,
                                     'n' => documents.size,
                                     'inserted_ids' => stored_documents.map { _1[:_id] }
                                   }, true)
    end

    def find(filter = nil, _options = {})
      # TODO: learn why the view is used and the possibility of
      # being substituted by a simple array
      # Mongo::Collection::View.new(self, filter || {}, options)

      unless filter.nil?
        return @@collections[@name].filter { |record| record >= filter }
      end

      @@collections[@name]
    end
  end
end
