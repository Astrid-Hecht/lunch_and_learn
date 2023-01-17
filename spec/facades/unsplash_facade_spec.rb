require 'rails_helper'

RSpec.describe UnsplashFacade do
  let(:photo_search) { UnsplashFacade.photo_search('China') }

  it 'searches photos and returns array of hits with only alt_tag and url', :vcr do
    expect(photo_search).to be_a(Array)

    first_hit = photo_search.first
    expect(first_hit).to be_a(Hash)

    expect(first_hit.keys).to eq(%i[url alt_tag])
    expect(first_hit[:alt_tag]).to be_a String
    expect(first_hit[:url]).to be_a String
  end
end
