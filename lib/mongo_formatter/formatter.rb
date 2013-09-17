require "mongo"

module MongoFormatter
  class Formatter
    include Mongo

    def initialize(runtime, path, options)
      @runtime = runtime

      @client = MongoClient.new("localhost", ENV["TEST_MONGO_PORT"])
      @db = @client.db(ENV["TEST_RESULT_DB"] || "meteor")
      @collection = @db.collection("results")

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
  end
end
