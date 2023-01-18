class Api::V1::RecipesController < ApplicationController
  def index
    search_checker(params[:country])
  end

  private

  def search_checker(country)
    country_list = CountryFacade.list_countries
    country ||= country_list.sample(1).first

    if country.count('a-zA-Z').positive? && !country_list.include?(country.downcase)
      render json: ErrorSerializer.new(Error.new(404, 'Country not found')), status: 404
    elsif (results = RecipeFacade.recipe_search(country)) && results
      render json: RecipeSerializer.new(results)
    else
      render json: { 'data': [] }
    end
  end
end
