require 'rubygems'
require 'logger'
require_relative 'scraper'

module UCAS
  class Application
    @logger = Logger.new('log/application.log', 'daily')
    @logger.level = Logger::INFO
    @logger.datetime_format = "%Y-%m-%d %H:%M:%S"
    
    def self.log(message)
      @logger.info(message)
    end
    
    def self.error(message)
      raise message
      @logger.fatal(message)
    end
    
  end
end