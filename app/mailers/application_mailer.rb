class ApplicationMailer < ActionMailer::Base
  default from: ENV['emailusername']
  layout 'mailer'
end
