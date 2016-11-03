class UsersController < ApplicationController
  include CASino::SessionsHelper
  layout 'embedded', only: [:edit_password, :add_phone, :add_email]
  before_action :ensure_service_allowed, only: [:new, :new_by_phone]
  before_action :ensure_signed_in, except: [:new, :new_by_phone, :create, :create_by_phone], unless: :format_json?
  before_action :authenticate_request!, if: :format_json?
  before_action :set_referrer, only: [:update, :add_phone, :add_email, :edit_password], unless: :format_json?
  before_action :set_x_frame_option, unless: :format_json?
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
      UserMailer.new_email_confirmation(@user, @token).deliver_later
      flash[:notice] = "验证邮件已发送"
      render 'users/notice',layout:'embedded'
    # handle_redirect_back
    else
      render :add_email,layout:'embedded'
    end
  end

  def new
    tgt = current_ticket_granting_ticket
    return handle_signed_in(tgt) unless params[:renew] || tgt.nil?
    redirect_to(params[:service]) if params[:gateway] && params[:service].present?
    @user = User.new
  end

  def new_by_phone
    tgt = current_ticket_granting_ticket
    return handle_signed_in(tgt) unless params[:renew] || tgt.nil?
    redirect_to(params[:service]) if params[:gateway] && params[:service].present?
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
    respond_to do |format|
      format.html { render :show }
      format.json { render json: @user }
    end
  end

  def create
    @user = User.new(user_create_params)
    params[:user][:register_from] = params[:service] if params[:service]
    if verify_rucaptcha?(@user) && @user.save
      @token = @user.confirmation_token
      UserMailer.email_confirmation(@user, @token).deliver_later
      @user_name = @user.name
      @email = @user.email
      handle_with_oauth2
      render 'users/before_confirmed'
    else
      render 'users/new'
    end
  end

  def create_by_phone
    params[:user][:register_from] = params[:service] if params[:service]
    @user = User.new(user_create_params)
    if params[:pin].blank?
      @user.errors.add(:base, t('phone_verification.blank'))
      render('/users/new_by_phone') && return
    end

    unless verify_sms? params[:user][:phone],params[:pin]
      @user.errors.add(:base, t('phone_verification.invalid'))
      render('/users/new_by_phone') && return
    end

    if @user.save
      handle_with_oauth2
      data = { authenticator: 'create_by_phone', user_data: { username: @user.phone, extra_attributes: { email: @user.email, nickname: @user.name, mobile: @user.phone, guid: @user.id } } }
      sign_in(data)
    else
      logger.debug @user.errors
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

  def get_avatar
    set_user
    if @user.avatar_url.present?
      send_file File.join(Rails.root,'public',@user.avatar_url), type: @user.avatar.content_type, disposition: 'inline'
    else
      send_file File.join(Rails.root,'public/default_avatar.jpg'), type: 'jpg', disposition: 'inline'
    end
  end

  def resend_email
    @user = User.find_by(email: params[:email])
    if @user && !@user.confirmed
      @user.send :create_confirmation_digest
      @user.save
      @token = @user.confirmation_token
      UserMailer.email_confirmation(@user, @token).deliver_later
      render 'users/confirmation_send'
    else
      render(status: 404)
    end
  end

  def update
    set_user
    unless params[:user][:phone].blank?
      unless verify_sms? params[:user][:phone],params[:pin]
        @user.errors.add(:base, t('phone_verification.invalid'))
        render('users/add_phone',layout:'embedded')  && return
      end
    end

    unless params[:user][:password].blank?
      current_password = params[:user].delete(:current_password)
      unless @user.authenticate(current_password)
        @user.errors.add(:base, t('current_password.wrong'))
        render('users/edit_password',layout:'embedded') && return
      end
    end

    respond_to do |format|
      if @user.update_attributes(user_params)
        format.html do
          flash[:notice] = "修改成功"
          render "/users/notice",layout:'embedded'
        end
        format.json { head :no_content }
        format.xml { render xml: {msg:"success"} }
      else
        # format.html { render Rails.application.routes.recognize_path(request.referer)[:action] }
        flash[:notice] = "修改失败"
        format.html { redirect_to(:back) }
        format.json { render json: @user.errors, status: :unprocessable_entity }
        format.xml { render xml: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :phone, :avatar, :avatar_cache, user_extra_attributes: [:info])
  end

  def user_create_params
    params.require(:user).permit(:name, :email, :password, :phone, :avatar, :avatar_cache).merge(register_from: params[:service])
  end

  def handle_redirect_back
    @referrer = session.delete(:referrer)
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
    if session[:user_id].blank?
      if  signed_in?
        guid = current_user.extra_attributes[:guid]
        session[:user_id] = guid
      else
        redirect_to '/login'
      end
    end
  end

  def set_user
    if format_json?
      @user = User.find(params[:id])
    else
      @user ||= User.find(session[:user_id])
    end
  end

  def verify_sms?(phone,pin)
    valid = false
    verification = Rails.cache.read(phone)
    valid = verification.present? && verification[:pin] == pin
    Rails.cache.delete(phone) if valid
    valid
  end

  def format_json?
    request.format.json?
  end

  # def set_referrer
  #   @referrer_host=URI.parse(request.referrer).host if request.referrer
  #   session[:referrer] = request.referrer if request.referrer && request.host != @referrer_host
  # end

  def set_x_frame_option
    baseurl = session[:referrer] if session[:referrer].present?
    if Settings.allow_from.include?(baseurl)
      response.headers['X-FRAME-OPTIONS'] = "ALLOW-FROM #{baseurl}"
    end
  end

  def ensure_service_allowed
    if params[:service].present? && !service_allowed?(params[:service])
      render 'service_not_allowed', status: :forbidden
    end
  end

end
