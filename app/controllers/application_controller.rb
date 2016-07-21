class ApplicationController < ActionController::Base
  attr_reader :current_service
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  def send_sms (phone,pin)
    logger.info phone
    logger.info pin
  end

  protected
   def authenticate_request!
     unless user_id_in_token?
       render json: { errors: ['Not Authenticated'] }, status: :unauthorized
       return
     end
     @current_service = auth_token[:service]
   rescue JWT::VerificationError, JWT::DecodeError
     render json: { errors: ['Not Authenticated'] }, status: :unauthorized
   end

   private
   def http_token
       @http_token ||= if request.headers['Authorization'].present?
         request.headers['Authorization'].split(' ').last
       end
   end

   def auth_token
     @auth_token ||= JsonWebToken.decode(http_token)
   end

   def user_id_in_token?
     http_token && auth_token && auth_token[:service].to_i
   end
end
