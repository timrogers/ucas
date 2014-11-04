require 'rubygems'
require 'mechanize'
require 'nokogiri'
require 'open-uri'

module UCAS
  class Scraper
    TRACK_URL = 'https://track.ucas.com/'
    def initialize(personal_id, password)
      
      if personal_id.empty? or password.empty?
        raise UCAS::ScraperException, "You must provide a personal ID and password"
        return
      end
      
      @agent = Mechanize.new
      @settings = {
        personal_id: personal_id,
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
        return parse
      rescue UCAS::ScraperException => e
        UCAS::Application.error(e.message)
        raise
      end
    end
    
    def fetch_metadata
      begin
        login
        go_to_choices
        return parse_course_data
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
        @agent.page.forms[0]["PersonalId"] = @settings[:personal_id]
        @agent.page.forms[0]["Password"] = @settings[:password]
        @agent.page.forms[0].submit(@agent.page.forms[0].button_with(:value => "Log in"))
        
        # Check that we successfully logged in, and raise an exception if not
        if @agent.page.search('.field-validation-error').any?
          raise UCAS::ScraperException, "The login details provided were incorrect"
        end
      end
      
      def go_to_choices
        @agent.page.link_with(text: "Your choices").click
      end
      
      def parse

        choice_rows = @agent.page.search('.offer-summary')
        course_codes = @agent.page.search('.offer-summary .offer-su .half .subheader .detail')

        results = []

        i = 0

        course_codes.each do |field|

          result = {}
            result[:universityCode] = choice_rows[i].search('.offer-su .half .header .detail')[0].text
            result[:courseCode] = field.text
            result[:decision] = choice_rows[i].search('.offer-su .half .header')[1].text.strip!
          
          i += 1

          results << result

        end

        results

      end
      
      def parse_course_data

        choice_rows = @agent.page.search('.offer-summary')
        course_codes = @agent.page.search('.offer-summary .offer-su .half .subheader .detail')

        results = []

        i = 0

        course_codes.each do |field|

          result = {}
            result[:universityCode] = choice_rows[i].search('.offer-su .half .header .detail')[0].text
            result[:courseCode] = field.text
            result[:university] = choice_rows[i].search('.offer-su .half .header')[0].children.first.text.strip!
            result[:course] = choice_rows[i].search('.offer-su .half .subheader')[0].children.first.text.strip!
            result[:starting] = choice_rows[i].search('.offer-su .half').xpath('//label[@for="choice_StartDate"]/..').children.last.text.strip!
            result[:decision] = choice_rows[i].search('.offer-su .half .header')[1].text.strip!

          i += 1

          results << result

        end

        results

      end
      
  end
end