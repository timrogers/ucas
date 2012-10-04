require 'rubygems'
require 'logger'
require_relative 'scraper'
require_relative 'exceptions'

module UCAS
  class Application
    @logger = Logger.new('log/application.log', 'daily')
    @logger.level = Logger::INFO
    @logger.datetime_format = "%Y-%m-%d %H:%M:%S"
    
    def self.log(message)
      @logger.info(message)
    end
    
    def self.error(message)
      @logger.fatal(message)
    end
    
  end
end