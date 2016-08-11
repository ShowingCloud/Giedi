class UsersController < ApplicationController
  include CASino::SessionsHelper
  before_action :ensure_signed_in, except:[:new, :new_by_phone, :create, :create_by_phone]
  skip_before_action :ensure_signed_in, only:[:show,:update], :if => :format_json?
  before_action :authenticate_request!, :if => :format_json?
  before_action :set_referrer,only:[:update,:add_phone,:add_email,:edit_password], :unless => :format_json?
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
      @token = @user.confirmation_token
      UserMailer.new_email_confirmation(@user,@token).deliver_later
      flash[:notice] = "验证邮件已发送"
      render "users/notice"
      #handle_redirect_back
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
    @user = User.new(user_create_params)
    params[:user][:register_from] = params[:service] if params[:service]
    if verify_rucaptcha?(@user) && @user.save
      @token=@user.confirmation_token
      UserMailer.email_confirmation(@user,@token).deliver_later
      # data = { authenticator: 'create_by_email', user_data: { username: params[:user][:email]}}
      # sign_in(data)
      @user_name = @user.name
      @email = @user.email
      render "users/before_confirmed"
    else
      render "users/new"
    end
  end

  def create_by_phone
    params[:user][:register_from] = params[:service] if params[:service]
    @user = User.new(user_create_params)
    return unless params[:pin] == PhoneVerification.find_by(phone: params[:user][:phone]).pin
    if @user.save
      data = { authenticator: 'create_by_phone', user_data: { username: params[:user][:phone]}}
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
    set_user
  end

  def resend_email
    @user=User.find_by(email:params[:email])
    if @user && !@user.confirmed
      @user.send:create_confirmation_digest
      @user.save
      @token = @user.confirmation_token
      UserMailer.email_confirmation(@user,@token).deliver_later
      render "users/confirmation_send"
    else
      render(:status => 404)
    end
  end

  def update
    return unless params[:pin] == PhoneVerification.find_by(phone: params[:user][:phone]).pin if params[:phone]
    set_user

     return unless params.has_key?[:current_password] && @user.authenticate(params[:current_password]) if params[:password]

    respond_to do |format|
      if @user.update_attributes(user_params)
        format.html {
          flash[:notice] = "修改成功"
          handle_redirect_back
        }
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

  def user_create_params()
    params.require(:user).permit(:name, :email, :password, :phone, :avatar, :avatar_cache,:register_from)
  end

  def handle_redirect_back
    @referrer  = session.delete(:referrer)
    if @referrer.present?
      render 'users/transfer_stop.html'
    else
      redirect_to '/profile'
    end
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
          guid = current_user.extra_attributes[:guid]
          # @user=User.find_by('name = :query OR email = :query OR phone = :query', query: username)
          session[:user_id]=guid
        else
          redirect_to '/login'
        end

      end
  end

  def set_user
    unless format_json?
      @user||=User.find(session[:user_id])
    else
      @user = User.find(params[:id])
    end
  end

  def format_json?
    request.format.json?
  end

  def set_referrer
    session[:referrer]=request.referrer unless request.host == URI.parse(request.referrer).host if request.referrer
  end
end
