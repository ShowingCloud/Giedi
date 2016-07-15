class PhoneVerificationsController < ApplicationController
  def new
    @phone_verification=PhoneVerification.new
    @user=User.new
  end

  def create
    if verify_rucaptcha?
      phone = Phonelib.parse(params[:phone])
      render json:{:msg=>"invalid phone number",:code=>"pv01"},status: 422 and return unless phone.valid?
      render json:{:msg=>"phone existed",:code=>"pv02"},status: 422 and return if User.find_by(phone:params[:phone]).present?
      pin = rand(1000..9999)
      send_sms params[:phone],pin
      @phone_verification=PhoneVerification.find_or_initialize_by(phone:params[:phone])
      @phone_verification.pin=pin
      @phone_verification.save
      head :no_content
    else
      head :forbidden
    end
  end

  private

end
