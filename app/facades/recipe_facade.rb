class EdamamFacade
  def self.recipe_search(query)
    target_fields = %i[title image url country]

    results = EdamamService.recipe_search(query)[:hits]

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
end