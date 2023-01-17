class Api::V1::RecipesController < ApplicationController
  def index
    country = params[:q]
    country_list = CountryFacade.list_countries
    country ||= country_list.sample(1)

    if country_list.include(country)
      render json: RecipeSerializer.new(RecipeFacade.recipe_search(country))
    else
      render json: []
    end
  end
end