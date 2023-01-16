class Recipe
  attr_reader :title,
              :url,
              :country,
              :image

  def initialize(recipe_facade_info)
    @title = recipe_facade_info[:title]
    @url = recipe_facade_info[:url]
    @country = recipe_facade_info[:country]
    @image = recipe_facade_info[:image]
  end
end