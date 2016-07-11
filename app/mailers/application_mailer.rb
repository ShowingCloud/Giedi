class ApplicationMailer < ActionMailer::Base
  default from: ENV['mailusername']
  layout 'mailer'
end
