class EmailConfirmationsController < ApplicationController
  include CASino::SessionsHelper
  def edit
    session.clear
    if params[:email]
      user = User.find_by(email: params[:email])
      if user.confirmation_expired?
          flash[:danger] = '验证邮件已过期'
          redirect_to '/login'
      else
        if user && !user.confirmed? && user.authenticated?(params[:id])
          user.update_attribute(:confirmed, true)
          user.update_attribute(:confirmed_at, Time.zone.now)
          flash[:success] = "邮箱认证成功!"
          redirect_to '/login?service'+URI.escape(user.register_from)
        else
          flash[:danger] = "无效的邮箱认证链接"
          redirect_to casino_path
        end
      end
    elsif params[:new_email]
      user = User.find_by(new_email: params[:new_email])
      if user.confirmation_expired?
          flash[:danger] = '验证邮件已过期'
          redirect_to '/login'
      else
        if user && user.authenticated?(params[:id])
          user.update_attribute(:email,params[:new_email])
          user.update_attribute(:confirmed,true)
          user.update_attribute(:confirmed_at, Time.zone.now)
          @confirm_result = "邮箱认证成功!"
          render "users/confirm_result"
        else
          @confirm_result = "无效的邮箱认证链接"
          render "users/confirm_result"
        end
      end
    end
  end
end
