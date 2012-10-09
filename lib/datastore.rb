require 'redis'
require 'redis-namespace'

module UCAS
  class Datastore
    @@redis = Redis.new
    @@adapter = Redis::Namespace.new("ucas-#{UCAS::Application.version}".to_sym, :redis => @@redis)
    
    def self.redis
      @@adapter
    end
    
    def self.get(key)
      @@adapter.get(key)
    end
    
    def self.set(key, value)
      @@adapter.set(key, value)
    end
  end
end