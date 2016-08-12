class ApplicationController < ActionController::Base
  attr_reader :current_service
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery unless: -> { request.format.json? }

  def send_sms (phone,pin)
    require 'submail'
    submail=Submail.new
    submail.sms(phone,pin).parsed_response
  end

  protected
   def authenticate_request!
      if request.headers['Authorization'].present?
         logger.info request.headers['Authorization']
      else
        logger.info "no Authorization"
      end
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
     http_token && auth_token && auth_token[:service].to_s
   end
end
