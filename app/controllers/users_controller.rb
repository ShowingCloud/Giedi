class UsersController < ApplicationController
  include CASino::SessionsHelper
  before_action :ensure_signed_in, except:[:new, :new_by_phone]
  skip_before_action :ensure_signed_in, only:[:show,:update], :if => :format_json?
  before_action :authenticate_request!, only:[:show,:update], :if => :format_json?

  def profile
    set_user
  end

  def add_phone
    set_user
  end

  def add_email
  end

  def add_email_sent
    if verify_rucaptcha?
      set_user
      @user.create_new_email_digest
      @user.update_attribute(:new_email, params[:user][:new_email])
      UserMailer.new_email_confirmation(@user).deliver_now
      render :profile
    else
      render :add_email
    end
  end

  def new
    @user = User.new
  end

  def new_by_phone
    @user = User.new
  end


  def show
    @user = User.find(params[:id])
      respond_to do |format|
      format.html { render :show }
      format.json { render json: @user,service_permission: ServicePermission.find_by_name(@current_service)}
    end
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
    @user = User.find(params[:id])
  end

  def edit_password
    set_user
  end

  def edit_avatar
    username = current_user.username
    @user=User.find_by('name = :query OR email = :query OR phone = :query', query: username)
  end

  def update
    return unless params[:pin] == PhoneVerification.find_by(phone: params[:user][:phone]).pin if params[:phone]
    set_user
    
     return unless params.has_key?[:current_password] && @user.authenticate(params[:current_password]) if params[:password]

    respond_to do |format|
      if @user.update_attributes(user_params)
        format.html { redirect_to '/profile' }
        format.json { head :no_content }
      else
        format.html { render Rails.application.routes.recognize_path(request.referer)[:action] }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end

  end

  private
  def user_params()
    params.require(:user).permit(:name, :email, :password, :phone, :avatar, :avatar_cache, user_extra_attributes: [:fullname, :gender, :birthday, :identity_card])
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

  def ensure_signed_in
      unless session[:user_id]
        if  signed_in?
          username = current_user.username
          @user=User.find_by('name = :query OR email = :query OR phone = :query', query: username)
          session[:user_id]=@user.id
        else
          redirect_to '/login'
        end

      end
  end

  def set_user
    @user||=User.find(session[:user_id])
  end

  def format_json?
    request.format.json?
  end
end
