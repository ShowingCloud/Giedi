class Api::UsersController < ApplicationController
  respond_to :json
  before_action :authenticate_request!
  before_action :set_permission

  def show
    @user = User.find(params[:id])
    if params[:profile] == 'true'
      respond_with @user
    else
      respond_with @user, serializer: BaseUserSerializer
    end
  end

  def update
    @user_extra = User.find(params[:id]).user_extra
    if @user_extra.update_attribute(:info, @user_extra.info.merge(params[:profile].to_hash))
      head :no_content
    else
      render json: @user_extra.errors, status: :unprocessable_entity
    end
  end

  private

  def set_permission
    puts "current_service:#{@current_service}"
    puts "action_name:#{action_name}"
  end

end
