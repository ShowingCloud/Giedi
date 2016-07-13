class PasswordResetsController < ApplicationController
  include CASino::SessionsHelper
  before_action :get_user,   only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]

  def new
  end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = "重置邮件已发送到你的邮箱"
      p "重置邮件已发送到你的邮箱"
      redirect_to '/'
    else
      flash.now[:danger] = "该邮箱未注册"
      p "该邮箱未注册"
      render 'new'
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

  private

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
