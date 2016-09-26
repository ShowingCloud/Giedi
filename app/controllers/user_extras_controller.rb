class UserExtrasController < ApplicationController
  before_action :authenticate_request!
  def show
    @user_extra = User.find(params[:user_id]).user_extra
    render json: @user_extra,service_permission: ServicePermission.find_by_name(@current_service)
  end

  def create
    @user_extra = User.find(params[:user_id]).user_extra
    if @user_extra.update_attribute(:info,@user_extra.info.merge(params[:info].to_hash))
      head :no_content
    else
      render json: @user_extra.errors, status: :unprocessable_entity
    end
  end

end
