require 'securerandom'

class Api::V1::FavoritesController < ApplicationController
  def index
    if key_has_user?
      render json: FavoriteSerializer.new(find_user.favorites), status: 200
    else
      render json: { data: { error: { status: 404, msg: 'placeholder error until error handling is set up' } } }
    end
  end
  
  def create
    if key_has_user? && find_user.favorites.new(fav_params).save
      render json: { success: 'Favorite added successfully' }, status: 201
    else
      render json: { data: { error: { status: 404, msg: 'placeholder error until error handling is set up' } } }
    end
  end

  private

  def fav_params
    params.permit(:country, :recipe_link, :recipe_title)
  end

  def key_has_user?
    params[:api_key].present? && User.exists?(api_key: params[:api_key])
  end

  def find_user
    User.find_by(api_key: params[:api_key])
  end
end
