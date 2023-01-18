require 'securerandom'

class Api::V1::FavoritesController < ApplicationController
  def index
    if key_has_user?
      render json: FavoriteSerializer.new(find_user.favorites), status: 200
    else
      render json: ErrorSerializer.new(Error.new(404, 'User not found')), status: 404
    end
  end

  def create
    if key_has_user?
      if find_user.favorites.new(fav_params).save
        render json: { success: 'Favorite added successfully' }, status: 201
      else
        render json: ErrorSerializer.new(Error.new(400, 'Bad request, check parameters')), status: 400
      end
    else
      render json: ErrorSerializer.new(Error.new(404, 'User not found')), status: 404
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
