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
            @phone_verification = PhoneVerification.find_or_initialize_by(phone: params[:phone])
            if @phone_verification.updated_at < 20.seconds.ago
              pin = rand(1000..9999)
              @phone_verification.pin = pin
              @phone_verification.save
              if send_sms(params[:phone], pin)["status"]=="success"
                head :no_content
              else
                render json: {msg:"sms send failed", code:"E004"},status: 500
              end
            else
              render json: {msg:"sms too often", code:"E005"},status: 403
            end

        else
            render json:{msg:"invalid captcha",code: "E000"},status: 403
        end
    end
end
