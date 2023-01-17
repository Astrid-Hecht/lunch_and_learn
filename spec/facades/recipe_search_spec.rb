require 'rails_helper'

RSpec.describe RecipeFacade do
  let(:recipe_search) { RecipeFacade.recipe_search('China') }

  context '#recipe_search' do
    it 'extracts relevant data', :vcr do
      expect(recipe_search).to be_a(Array)

      first_hit = recipe_search.first

      expect(first_hit).to be_an_instance_of(Recipe)

      expect(first_hit.title).to be_a(String)
      expect(first_hit.url).to be_a(String)
      expect(first_hit.country).to be_a(String)
      expect(first_hit.image).to be_a(String)
    end
  end
end
