# Require all the parts of the application from lib/
Dir[File.dirname(__FILE__) + '/lib/*.rb'].each {|file| require file }

# Bring in the settings constants from settings.rb
require File.join(File.dirname(__FILE__), 'settings')

scraper = UCAS::Scraper.new(UCAS_PERSONAL_ID, UCAS_USERNAME, UCAS_PASSWORD)
results = scraper.scrape
results.each do |result|
  
  begin
    entry = UCAS::Datastore.get(result[:code])
    
  rescue Exception => e
    UCAS::Application.error("There was an error in reading from Redis: #{e.message}")
    raise
  end
  
  if entry[:decision] != result[:decision]
    # The decision for that university has changed - hooray!
    
    entry[:decision] = result[:decision] # Get ready to save the new application status
    UCAS::Application.log("Change of status for the course #{entry[:course]} at #{entry[:university]}: '#{entry[:decision]}' (#{entry[:code]})")
    UCAS::Notifier.notify(entry)
    
    begin
      UCAS::Datastore.set(entry[:code], entry)
    rescue Exception => e
      UCAS::Application.error("There was an error in Redis: #{e.message}")
      raise
    end
      
  else
    # Nothing has changed since last time
    UCAS::Application.log("There has been no change of status for the course '#{entry[:course]}' (#{entry[:code]}) at #{entry[:university]}.")
  end
end
