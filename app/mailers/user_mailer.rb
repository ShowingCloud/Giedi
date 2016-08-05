class UserMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.email_confirmation.subject
  #
  def email_confirmation(user,token)
    @user = user
    @token = token
    mail to: user.email, subject: "DOMELAB邮箱验证"
  end

  def new_email_confirmation(user,token)
    @user = user
    @token = token
    mail to: user.new_email, subject: "DOMELAB邮箱验证"
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.password_reset.subject
  #
  def password_reset(user)
    @user = user
    mail to: user.email, subject: "DOMELAB重置密码"
  end
end
