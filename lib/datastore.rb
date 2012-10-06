require 'redis'

module UCAS
  class Datastore
    @@redis = Redis.new
    
    def self.redis
      @@redis
    end
    
    def self.get(key)
      @@redis.get(key)
    end
    
    def self.set(key, value)
      @@redis.set(key, value)
    end
  end
end