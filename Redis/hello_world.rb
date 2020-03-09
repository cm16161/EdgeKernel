require 'redis'

require 'redis'
redis = Redis.new(host: "localhost")

redis.set("a", "test")

print(redis.get("a"))
