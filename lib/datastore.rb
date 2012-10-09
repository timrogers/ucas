require 'redis'
require 'redis-namespace'
require 'json'

module UCAS
  class Datastore
    @@redis = Redis.new
    @@adapter = Redis::Namespace.new("ucas-#{UCAS::Application.version}".to_sym, :redis => @@redis)
    
    def self.redis
      @@adapter
    end
    
    def self.load(key)
      JSON.parse(@@adapter.get(key))
    end
    
    def self.set(key, value)
      @@adapter.set(key, value.to_json)
    end
  end
end