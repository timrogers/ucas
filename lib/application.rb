require 'rubygems'
require 'logger'
require 'redis'
require File.join(File.dirname(__FILE__), 'scraper')
require File.join(File.dirname(__FILE__), 'exceptions')
require File.join(File.dirname(__FILE__), 'datastore')
require File.join(File.dirname(__FILE__), 'notifier')


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