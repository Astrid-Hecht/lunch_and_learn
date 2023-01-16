require 'rails_helper'

RSpec.describe Recipe do
  let(:recipe_facade_data) do
    { title: 'Grilled cheese', url: 'www.grilledplease.com', country: 'United States', image: 'www.pic.com' }
  end
  let(:recipe) { Recipe.new(recipe_facade_data) }

  it 'attributes' do
    expect(recipe.title).to eq('Grilled cheese')
    expect(recipe.url).to eq('www.grilledplease.com')
    expect(recipe.country).to eq('United States')
    expect(recipe.image).to eq('www.pic.com')
  end
end
