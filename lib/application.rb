require 'rubygems'
require 'logger'

module UCAS
  class Application
    @logger = Logger.new('log/application.log', 'daily')
    @logger.level = Logger::INFO
    @logger.datetime_format = "%Y-%m-%d %H:%M:%S"
    
    def self.log(message)
      @logger.info(message)
    end
    
  end
end