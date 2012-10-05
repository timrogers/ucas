require 'rubygems'
require 'logger'
require 'redis'
require_relative 'scraper'
require_relative 'exceptions'
require_relative 'datastore'
require_relative 'notifier'


module UCAS
  class Application
    @logger = Logger.new('log/application.log', 'daily')
    @logger.level = Logger::INFO
    @logger.datetime_format = "%Y-%m-%d %H:%M:%S"
    
    def self.log(message)
      puts message
      @logger.info(message)
    end
    
    def self.error(message)
      puts message
      @logger.fatal(message)
    end
    
  end
end