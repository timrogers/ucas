require('./lib/application')
require('./settings')

scraper = UCAS::Scraper.new(UCAS_PERSONAL_ID, UCAS_USERNAME, UCAS_PASSWORD)
results = scraper.scrape

results.each do |result|
  previous_decision = UCAS::Datastore.adapter.get(result[:code])
  if previous_decision != result[:decision]
    # The decision for that university has changed - hooray!
  end
end
