module Mongo
  class Client
    attr_reader :collections

    def [](collection_name, options = {})
      @collections = {} if @collections.nil?

      unless @collections.key? collection_name
        @collections[collection_name] = MongoRubyServer::InMemoryCollection.new(nil, collection_name, options)
      end

      @collections[collection_name]
      # @collect ||= MongoRubyServer::InMemoryCollection.new(nil, collection_name, options)
    end
  end
end
