require 'securerandom'

class Api::V1::UsersController < ApplicationController
  def create
    if (new_user = User.new(user_params)).save
      render json: UserSerializer.new(new_user), status: :created
    else
      render json: { data: { error: { status: 404, msg: 'placeholder error until error handling is set up' } } }
    end
  end

  private

  def user_params
    params[:api_key] = SecureRandom.uuid
    params[:email].downcase! if params[:email].present?
    params.permit(:name, :email, :api_key)
  end
end
