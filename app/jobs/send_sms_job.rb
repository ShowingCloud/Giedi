class SendSmsJob < ActiveJob::Base
  queue_as :default

  def perform(phone)
    require 'submail'
    pin = rand.to_s[2..7]
    Rails.cache.write(phone, { pin: pin, send_at: DateTime.now }, expires_in: 10.minute)
    submail=Submail.new
    submail.sms(phone,pin)
  end
end
