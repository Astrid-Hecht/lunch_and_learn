class EdamamFacade
  def self.recipe_search(query)
    target_fields = %i[label image url country]

    results = EdamamService.recipe_search(query)[:hits]

    results.map! do |raw_hit|
      raw_hit[:recipe]
    end

    results.map! do |hit|
      hit[:country] = query
      Recipe.new(hit.select { |key, _value| target_fields.include?(key) })
    end
    results
  end
end