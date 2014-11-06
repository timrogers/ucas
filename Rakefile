Dir[File.dirname(__FILE__) + '/lib/*.rb'].each {|file| require file }
require File.join(File.dirname(__FILE__), 'settings')

namespace :ucas do
  task :metadata do
    UCAS::Application.log("Fetching course metadata from database...")
    scraper = UCAS::Scraper.new(UCAS_PERSONAL_ID, UCAS_PASSWORD)
    results = scraper.fetch_metadata
    results.each do |entry|
      UCAS::Application.log("Found course #{entry[:course]} (#{entry[:courseCode]}) at #{entry[:university]}. Saving...")
      UCAS::Datastore.set(entry[:universityCode] + '-' + entry[:courseCode], entry)
    end
  end
end
