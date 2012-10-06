# Require all the parts of the application from lib/
Dir[File.dirname(__FILE__) + '/lib/*.rb'].each {|file| require file }

# Bring in the settings constants from settings.rb
require File.join(File.dirname(__FILE__), 'settings')

scraper = UCAS::Scraper.new(UCAS_PERSONAL_ID, UCAS_USERNAME, UCAS_PASSWORD)
results = scraper.scrape

results.each do |result|
  
  begin
    previous_decision = UCAS::Datastore.get(result[:code])
  rescue Exception => e
    UCAS::Application.error("There was an error in reading from Redis: #{e.message}")
    raise
  end
  
  if previous_decision != result[:decision]
    # The decision for that university has changed - hooray!
        
    UCAS::Application.log("Change of status for the course #{result[:code]}: #{result[:decision_text]}")
    UCAS::Notifier.notify(result)
    
    begin
      UCAS::Datastore.set(result[:code], result[:decision])
    rescue Exception => e
      UCAS::Application.error("There was an error in Redis: #{e.message}")
      raise
    end
      
  else
    # Nothing has changed since last time
    UCAS::Application.log("There has been no change of status for the course #{result[:code]}.")
  end
end
