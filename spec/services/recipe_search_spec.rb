require 'rails_helper'

RSpec.describe RecipeService do
  let(:recipe_search) { RecipeService.recipe_search("China") }

  it 'can search products', :vcr do
    expect(recipe_search).to be_a(Hash)
    expect(recipe_search[:hits]).to be_a(Array)

    first_hit = recipe_search[:hits].first[:recipe]
    expect(first_hit).to be_a(Hash)

    expect(first_hit[:image]).to be_a(String)
    expect(first_hit[:label]).to be_a(String)
    expect(first_hit[:url]).to be_a(String)
  end
end
