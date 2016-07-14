class PasswordResetsController < ApplicationController
  include CASino::SessionsHelper
  before_action :get_user,   only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]

  def new
  end

  def new_by_phone
    @user = User.new
  end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = "重置邮件已发送到你的邮箱"
      redirect_to '/'
    else
      flash.now[:danger] = "该邮箱未注册"
      render 'new'
    end
  end

  def create_by_phone
    if verify_rucaptcha?
      @user = User.find_by(phone: params[:phone])
      if @user
        pin = rand(1000..9999)
        @user.update(reset_pin:pin,reset_pin_sent_at:Time.zone.now)
        send_sms params[:phone],pin
        head :no_content
      else
        flash.now[:danger] = "该手机未注册"
        render 'new_by_phone'
      end
    else
      head :forbidden
    end
  end

  def edit
  end

  def update
    if params[:user][:password].empty?
      @user.errors.add(:password, "不能为空")
      render 'edit'
    elsif @user.update_attributes(user_params)
      data = { authenticator: 'ActiveRecord', user_data: { username: params[:email]}}
      flash[:success] = "密码已重置."
      sign_in(data)
    else
      render 'edit'
    end
  end

  def update_by_phone
    @user=User.find_by(phone: params[:user][:phone])
    render 'new_by_phone'and return unless params[:reset_pin] == @user.reset_pin
    if params[:user][:password].empty?
      @user.errors.add(:password, "不能为空")
      render 'new_by_phone'
    elsif @user.update_attributes(user_params)
      data = { authenticator: 'ActiveRecord', user_data: { username: params[:email]}}
      flash[:success] = "密码已重置."
      sign_in(data)
    else
      render 'new_by_phone'
    end
  end

  private

  def handle_signed_in(tgt, options = {})
    if tgt.awaiting_two_factor_authentication?
      @ticket_granting_ticket = tgt
      render 'casino/sessions/validate_otp'
    else
      if params[:service].present?
        begin
          handle_signed_in_with_service(tgt, options)
          return
        rescue Addressable::URI::InvalidURIError => e
          Rails.logger.warn "Service #{params[:service]} not valid: #{e}"
        end
      end
      redirect_to '/sessions', status: :see_other
    end
  end

    def user_params
        params.require(:user).permit(:password, :password_confirmation)
    end

  def check_expiration
    if @user.password_reset_expired?
      flash[:danger] = "Password reset has expired."
      redirect_to new_password_reset_url
    end
  end

  def get_user
      @user = User.find_by(email: params[:email])
  end

  def valid_user
      unless (@user && @user.confirmed? &&
              @user.authenticated_reset?(params[:id]))
        redirect_to '/'
      end
  end
end
