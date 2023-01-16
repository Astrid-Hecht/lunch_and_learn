class RecipeService
  def self.conn
    Faraday.new(url: "https://api.edamam.com/api") do |f|
      f.params['app_id'] = ENV['edamam_recipe_id']
      f.params['app_key'] = ENV['edamam_recipe_key']
      f.params['type'] = 'public'
      f.params['beta'] = 'true'
    end
  end

  def self.recipe_search(query)
    response = conn.get("/api/recipes/v2?q=#{query}")

    # ruby doesnt like the nulls, so had to do a gsub
    JSON.parse(response.body.gsub('null', '"null"'), symbolize_names: true)
  end
end