require 'rubygems'
require 'logger'

module UCAS
  class Application
    @@version = "2.0"
    
    def self.version
      @@version
    end
    
    @logger = Logger.new(File.join(File.dirname(__FILE__), '..', 'log', 'application.log'), 'daily')
    @logger.level = Logger::INFO
    @logger.datetime_format = "%Y-%m-%d %H:%M:%S"
    @logger.progname = "UCAS v#{@@version}"
    
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