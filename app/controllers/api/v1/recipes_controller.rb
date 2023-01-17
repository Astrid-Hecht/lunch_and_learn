class Api::V1::RecipesController < ApplicationController
  def index
    render json: search_checker(params[:country])
  end

  private

  def search_checker(country)
    country_list = CountryFacade.list_countries
    country ||= country_list.sample(1).first

    if country.count('a-zA-Z').positive? && !country_list.include?(country.downcase)
      { data: { error: { status: 404, msg: 'placeholder error until error handling is set up' } } }
    elsif (results = RecipeFacade.recipe_search(country))
      RecipeSerializer.new(results)
    else
      { 'data': [] }
    end
  end
end
