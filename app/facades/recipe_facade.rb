class RecipeFacade
  def self.recipe_search(query)
    results = RecipeService.recipe_search(query)

    if results[:count].positive?
      search_mapper(results[:hits], query)
    else
      false
    end
  end

  def self.search_mapper(results, query)
    target_fields = %i[title image url country]

    results.map! do |raw_hit|
      raw_hit[:recipe]
    end

    results.map! do |hit|
      hit[:country] = query
      hit[:title] = hit[:label]
      Recipe.new(hit.select { |key, _value| target_fields.include?(key) })
    end
    results
  end

  private_class_method :search_mapper
end
