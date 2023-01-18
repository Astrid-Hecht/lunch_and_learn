class Api::V1::LearningResourcesController < ApplicationController
  def index
    if params[:country].present? && CountryFacade.list_countries.include?(params[:country].downcase)
      render json: LearningResourceSerializer.new(learning_resource_constructor(params[:country]))
    elsif params[:country].present?
      render json: ErrorSerializer.new(Error.new(404, 'Country not found')), status: 404
    else
      render json: ErrorSerializer.new(Error.new(400, 'Missing or invalid parameters')), status: 400
    end
  end

  def learning_resource_constructor(country)
    video = YoutubeFacade.mr_history_search(country)
    images = UnsplashFacade.photo_search(country)
    LearningResource.new(country, video, images)
  end
end
