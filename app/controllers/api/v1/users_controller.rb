require 'securerandom'

class Api::V1::UsersController < ApplicationController
  def create
    if (new_user = User.new(user_params)).save
      render json: UserSerializer.new(new_user), status: :created
    else
      render json: ErrorSerializer.new(Error.new(400, 'Bad request, check your parameters')), status: 400
    end
  end

  private

  def user_params
    params.permit(:name, :email, :api_key)
  end
end
