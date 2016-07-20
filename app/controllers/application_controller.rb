class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  def send_sms (phone,pin)
    logger.info phone
    logger.info pin
  end
end
