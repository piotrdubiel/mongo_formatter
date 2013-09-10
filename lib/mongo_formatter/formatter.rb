require "mongo"

module MongoFormatter
  class Formatter
    include Mongo

    def initialize(runtime, path, options)
      @runtime = runtime

      @client = MongoClient.new("localhost", ENV["TEST_MONGO_PORT"])
      @db = @client.db(ENV["TEST_RESULT_DB"] || "meteor")
      @collection = @db.collection("results")

      @result = {device: device_name}
    end

    def after_features(features)
      scenarios = @runtime.scenarios.map do |scenario|
          {name: scenario.name,
           status: scenario.status.to_s,
           exception: scenario.exception ? scenario.exception.message : ""}
        end
      @result["scenarios"] = scenarios
      @collection.update({device: @result['device']}, {:$set => @result}, {upsert: true})
    end

    private

   def device_name
      ENV["DEVICE_NAME"] || ENV["ADB_DEVICE_ARG"] || ENV["DEVICE_TARGET"]
    end
  end
end
