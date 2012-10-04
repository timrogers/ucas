require 'rubygems'
require 'mechanize'
require 'nokogiri'
require 'open-uri'

module UCAS
  class Scraper
    TRACK_URL = 'https://track.ucas.com/ucastrack/Login.jsp'
    def initialize(personal_id, username, password)
      
      if personal_id.empty? or username.empty? or password.empty?
        raise UCAS::ScraperException, "You must provide a personal ID, username and password"
        return
      end
      
      @agent = Mechanize.new
      @settings = {
        personal_id: personal_id,
        username: username,
        password: password
      }
      
    end
    
    def agent
      @agent
    end
    
    def settings
      @settings
    end
    
    def scrape
      begin
        login
        go_to_choices
      rescue UCAS::ScraperException => e
        UCAS::Application.error(e.message)
        raise
      end
    end
    
    private
      def login
        # Go to the UCAS track site
        UCAS::Application.log("Logging into UCAS at #{TRACK_URL}")
        @agent.get(TRACK_URL)
        
        # Fill in the login form, and then submit it
        @agent.page.forms[0]["appNo"] = @settings[:personal_id]
        @agent.page.forms[0]["username"] = @settings[:username]
        @agent.page.forms[0]["appPassword"] = @settings[:password]
        @agent.page.forms[0].submit(@agent.page.forms[0].button_with(:value => "login"))
        
        # Check that we successfully logged in, and raise an exception if not
        if @agent.page.search('.errormsg').any?
          raise UCAS::ScraperException, "The login details provided were incorrect"
        end
      end
      
      def go_to_choices
        @agent.page.link_with(text: "choices ").click
      end
  end
end