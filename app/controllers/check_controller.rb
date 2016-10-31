class CheckController < ApplicationController
  def username
    @user = User.where('name = ?',params[:username]).first
    if @user.present?
      render json: {message: 'User exists', available: false}, status: 200
    else
      render json: {message: 'User Does not exist', available: true}.as_json, status: 200
    end
  end

  def email
    @user = User.where('email = ?',params[:email]).first
    if @user.present?
      render json: {:message => 'Email exists', :available => false}, status: 200
    else
      render json: {:message => 'Email Does not exist', :available => true}, status: 200
    end
  end
end
