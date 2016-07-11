class UsersController < ApplicationController
  include CASino::SessionsHelper
  def show
     @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if verify_rucaptcha?(@user) && @user.save
      UserMailer.email_confirmation(@user).deliver_later
      data = { authenticator: 'ActiveRecord', user_data: { username: params[:user][:email]}}
      sign_in(data)
    else
      render "users/new"
    end
  end

  def edit
  end

  private
  def user_params
    params.require(:user).permit(:name, :email, :password, :phone)
  end

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
end
