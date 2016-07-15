class UsersController < ApplicationController
  include CASino::SessionsHelper
  def profile
    username = current_user.username
    @user=User.where('name = :query OR email = :query OR phone = :query', query: username).take
  end

  def add_phone
    username = current_user.username
    @user=User.where('name = :query OR email = :query OR phone = :query', query: username).take
  end

  def new
    @user = User.new
  end

  def new_by_phone
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if verify_rucaptcha?(@user) && @user.save
      UserMailer.email_confirmation(@user).deliver_now
      data = { authenticator: 'ActiveRecord', user_data: { username: params[:user][:email]}}
      sign_in(data)
    else
      render "users/new"
    end
  end

  def create_by_phone
    @user = User.new(user_params)
    return unless params[:pin] == PhoneVerification.find_by(phone: params[:user][:phone]).pin
    if @user.save
      data = { authenticator: 'ActiveRecord', user_data: { username: params[:user][:phone]}}
      sign_in(data)

    else
      render '/users/new_by_phone'
    end
  end


  def edit
  end

  def update
    return unless params[:pin] == PhoneVerification.find_by(phone: params[:user][:phone]).pin
    username = current_user.username
    @user=User.where('name = :query OR email = :query OR phone = :query', query: username).take
    if @user.update_attributes(user_params)
      render 'profile'
    else
      render 'add_phone'
    end
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
