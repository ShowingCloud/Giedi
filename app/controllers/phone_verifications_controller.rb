class PhoneVerificationsController < ApplicationController
  def new
    @phone_verification=PhoneVerification.new
    @user=User.new
  end

  def create
    pin = rand(1000..9999)
    @phone_verification=PhoneVerification.new(phone:params[:phone],pin:pin)
    if verify_rucaptcha? && @phone_verification.save
      p pin
      head :no_content
    else
      render json:{:status=>0}
    end
  end

  private


end
