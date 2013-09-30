require "mongo"
require "uri"

module MongoFormatter
  class Formatter
    include Mongo

    def initialize(runtime, path, options)
      @runtime = runtime
      @uri = URI(path)

      init_mongo_client

      @result = {:name => device_name, :id => device_id, :date => Time.new}
    end

    def after_features(features)
      scenarios = @runtime.scenarios.map do |scenario|
        {name: scenario.name,
         status: scenario.status.to_s,
         exception: scenario.exception ? scenario.exception.message : ""}
      end
      @result["scenarios"] = scenarios
      @collection.update({:id => @result[:id]}, {:$set => @result}, {:upsert => true})
    end

    private

    def device_name
      ENV["DEVICE_NAME"] || device_id  
    end

    def device_id
      ENV["ADB_DEVICE_ARG"] || ENV["DEVICE_TARGET"]
    end

    def init_mongo_client
      raise "Missing 'mongodb://' scheme in URI: #{@uri}" unless @uri.scheme == 'mongodb'
      @client = MongoClient.new(@uri.host, @uri.port)
      @db = @client.db(@uri.path.split('/')[1])
      @collection = @db.collection("results")
    rescue Mongo::ConnectionFailure
      print "No connection found with URI => #{@uri}\n"
      print "WARNING => No results will be saved to MongoDB\n"
      @collection = NoClient.new
    end
  end

  class NoClient
    def method_missing(method, *args, &block)
      p method
    end
  end
end
