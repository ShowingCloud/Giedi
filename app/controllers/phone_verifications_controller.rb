class PhoneVerificationsController < ApplicationController
  def new
    @phone_verification = PhoneVerification.new
    @user = User.new
  end

  def create
    if verify_rucaptcha?
      phone = Phonelib.parse(params[:phone])
      render(json: { msg: 'invalid phone number', code: 'E001' }, status: 422) && return unless phone.valid? && phone.type == :mobile
      render(json: { msg: 'phone existed', code: 'E002' }, status: 422) && return if User.find_by(phone: params[:phone]).present?
      @phone_verification = Rails.cache.read(params[:phone])
      render json: { msg: 'sms too often', code: 'E005' }, status: 403 && return if @phone_verification.present? && @phone_verification.send_at < 20.seconds.ago
      pin = rand.to_s[2..7]
      Rails.cache.write(params[:phone], { pin: pin, send_at: DateTime.now }, expires_in: 10.minute)
      if send_sms(params[:phone], pin)['status'] == 'success'
        head :no_content
      else
        render json: { msg: 'sms send failed', code: 'E004' }, status: 500
      end
    else
      render json: { msg: 'invalid captcha', code: 'E000' }, status: 403
    end
  end
end
