class ApplicationMailer < ActionMailer::Base
  default from: Settings.email.account
  layout 'mailer'
end
