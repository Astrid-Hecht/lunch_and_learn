require 'rails_helper'

RSpec.describe CountryService do
  let(:country_list) { CountryService.list_countries }

  it 'returns all countries', :vcr do
    expect(country_list).to be_a(Array)

    first_hit = country_list[0]
    expect(first_hit).to be_a(Hash)

    expect(first_hit[:name]).to be_a(String)
  end
end
