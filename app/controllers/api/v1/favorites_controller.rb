require 'securerandom'

class Api::V1::FavoritesController < ApplicationController
  def create
    if has_user? && find_user.favorites.new(fav_params).save
      render json: { success: 'Favorite added successfully' }, status: :created
    else
      render json: { data: { error: { status: 404, msg: 'placeholder error until error handling is set up' } } }
    end
  end

  private

  def fav_params
    params.permit(:country, :recipe_link, :recipe_title)
  end

  def has_user?
    User.exists?(api_key: params[:api_key])
  end

  def find_user
    User.find_by(api_key: params[:api_key])
  end
end
