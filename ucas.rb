require('./lib/application')
require('./settings')

scraper = UCAS::Scraper.new(UCAS_PERSONAL_ID, UCAS_USERNAME, UCAS_PASSWORD)
results = scraper.scrape

results.each do |result|
  
  begin
    previous_decision = UCAS::Datastore.get(result[:code])
  rescue Exception => e
    UCAS::Application.error("There was an error in reading from Redis: #{e.message}")
  end
  
  if previous_decision != result[:decision]
    # The decision for that university has changed - hooray!
    puts "There has been a change of status for the course #{result[:code]}."
    UCAS::Application.log("Change of status for the course #{result[:code]}: #{result[:decision]}")
    
    begin
      UCAS::Datastore.set(result[:code], result[:decision])
    rescue Exception => e
      UCAS::Application.error("There was an error in Redis: #{e.message}")
    ensure
      #UCAS::Notifier.notify(result)
    end
      
  else
    # Nothing has changed since last time
    UCAS::Application.log("There has been no change of status for the course #{result[:code]}.")
  end
end
