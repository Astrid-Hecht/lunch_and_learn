require 'rails_helper'

RSpec.describe CountryFacade do
  let(:country_list) { CountryFacade.list_countries }
  
  context "#list_countries" do
    it 'extracts relevant data', :vcr do
      expect(country_list).to be_a(Array)

      first_hit = country_list[0]

      expect(first_hit).to be_a(String)
    end
  end
end
