class Api::V1::LearningResourcesController < ApplicationController
  def index
    if CountryFacade.list_countries.include?(params[:country].downcase)
      render json: LearningResourceSerializer.new(learning_resource_constructor(params[:country]))
    else
      render json: { data: { error: { status: 404, msg: 'placeholder error until error handling is set up' } } }
    end
  end

  def learning_resource_constructor(country)
    video = YoutubeFacade.mr_history_search(country)
    images = UnsplashFacade.image_search(country)
    LearningResource.new(country, video, images)
  end
end
