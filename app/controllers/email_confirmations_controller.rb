class EmailConfirmationsController < ApplicationController
  include CASino::SessionsHelper

  def edit
    if params[:email]
      user = User.find_by(email: params[:email])
      if user && !user.confirmed? && user.authenticated?(params[:id])
        user.update_attribute(:confirmed,    true)
        user.update_attribute(:confirmed_at, Time.zone.now)
        flash[:success] = "邮箱认证成功!"
        redirect_to casino_path
      else
        flash[:danger] = "无效的邮箱认证链接"
        redirect_to casino_path
      end
    elsif params[:new_email]
      user = User.find_by(new_email: params[:new_email])
      if user && !user.confirmed? && user.authenticated?(params[:id])
        user.update_attribute(:email,params[:new_email])
        user.update_attribute(:confirmed,true)
        user.update_attribute(:confirmed_at, Time.zone.now)
        flash[:success] = "邮箱认证成功!"
        redirect_to casino_path
      else
        flash[:danger] = "无效的邮箱认证链接"
        redirect_to casino_path
      end
    end
  end

end
