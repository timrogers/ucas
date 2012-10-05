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
        @@twilio.account.sms.messages.create(
          from: TWILIO_FROM,
          to: PHONE_NUMBER,
          body: "Status change in application to #{result[:university]} for #{result[:code]}: #{result[:decision_text]}"
        )
      rescue Exception => e
        UCAS::Application.error("Couldn't send Twilio SMS: #{e.message}")
        raise
      end
      
      # And now send an email...
      begin
        Mail.deliver do
          from    "ucas@ec2.timrog.net"
          to      EMAIL_ADDRESS
          subject "UCAS application change"
          body    "Status change in application to #{result[:university]} for #{result[:code]}: #{result[:decision_text]}"
        end
      rescue Exception => e
        UCAS::Application.error("Couldn't send email notification: #{e.message}")
      end
    end
  end
end