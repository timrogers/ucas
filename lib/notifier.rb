require 'twilio-ruby'
require 'mail'
require_relative '../settings'

module UCAS
  class Notifier
    def self.notify(result)
      UCAS::Application.log("Sending notifications for status change...")

      # Send an SMS with the application change
      begin
        @@twilio = Twilio::REST::Client.new TWILIO_SID, TWILIO_TOKEN
        PHONE_NUMBERS.each do |number|
          @@twilio.account.sms.messages.create(
            from: TWILIO_FROM,
            to: number,
            body: "Status change in application to #{result[:university]} for #{result[:course]}: #{friendly_decision(result[:decision])}"
          )
        end
      rescue Exception => e
        UCAS::Application.error("Couldn't send Twilio SMS: #{e.message}")
        raise
      end

      # And now send an email...
      begin
        email = "There has been a status change in the UCAS application to #{result[:university]} for the course #{result[:course]}.

        The new status of that application is #{friendly_decision(result[:decision])}"
        Mail.deliver do
          from    FROM_EMAIL_ADDRESS
          to      EMAIL_ADDRESS
          subject "UCAS application change"
          body    email
        end
      rescue Exception => e
        UCAS::Application.error("Couldn't send email notification: #{e.message}")
      end
    end

    private
    def self.friendly_decision(decision)
      if decision == "" || decision == nil
        "<no decision>"
      else
        decision
      end
    end

  end
end