# UCAS Track Scraper

In the UK, all university applications go through the [UCAS](http://www.ucas.com) system. Once you've applied, there's a system called UCAS Track which is used to keep an eye on your applications and respond to any offers you receive from universities. None of the UCAS Track system, nor any of the rest of UCAS's expansive data on further and higher education is openly available. They don't have an API or anything like that.

I created this Ruby script, making use of Mechanize with Nokogiri and Redis as a backend, to logon to the UCAS Track service for me, check the status of my applications and email and text me if anything has changed. This is helpful because although UCAS sends notification emails, they're very arcane in that they only say "something has changed with your UCAS application", and they might be delayed depending on how the system works.

This script logs in, navigates to the choices page, parses the table to find all the relevant details and then performs notifications based on this, storing all the results in Redis.

## Setup

* Make sure the Redis database system is installed - this will probably be available in your platform's package manager. Have a google.

* Clone the application from the Git repository

`git clone git://github.com/timrogers/ucas.git`

* Head into the directory, and then run `bundle install` to install the relevant dependencies

* Create your own settings.rb file using the template found in settings.rb.example

* Set up a directory and file for logs to be put into from the application's runtimes:

```shell
mkdir log
touch log/application.log
```

* Run the Raketask using `rake ucas:metadata` from the shell to load up all the data on your courses for future use. This fetches information on the courses you've applied to, for instance the degree name and the university.

* Run the ucas.rb script as often as you want and it'll give you your notifications:

`ruby ucas.rb`

* Logging output will be printed to your console, and also to the log file you made a little earlier

* *Bonus step* - Set up sendmail so the script can send notification emails, or implement some other email library

## Want a frontend?

I wanted to display this as a [pretty website](http://ucas.tim-rogers.co.uk) so I made a quick Sinatra app that reads from Redis, using the lib/datastore.rb to do this. You can download the source and run it for yourself from the repo [here](https://github.com/timrogers/ucas-frontend).

## Dependencies

This doesn't use too many other gems, but for clarity, I'll list them all and explain their purpose.

* __mechanize__ - Used for interacting with the UCAS Track website
* __nokogiri__ - Allows the app to traverse HTML and XML documents, to fetch data from the UCAS pages for instance
* __mail__ - Used for sending notification emails. __You'll need Sendmail on your server for this.__ You might like to swap this for something else.
* __redis__ - Awesome key-value storage for database win.
* __redis-namespace__ - Easier versioning for the application, meaning the dataset can change as I update this
* __twilio-ruby__ - Enables SMS notifications
* __json__ - Objects are stored in Redis as lovely JSON, and must be brought back into Ruby form
* __rake__ - Used for the `ucas:metadata` task that prepares the application

## With thanks to...

My colleague at GoCardless [@alan](https://github.com/alan) for his help and advice. 

Owen Stephens of Overdue Ideas who [created](http://www.meanboyfriend.com/overdue_ideas/2009/10/ucas-course-code-lookup/) an API to lookup UCAS course codes for their course name, saving me much time and effort.

