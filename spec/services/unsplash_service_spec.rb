require 'rails_helper'

RSpec.describe UnsplashService do
  let(:photo_search) { UnsplashService.photo_search('China') }

  it 'can search photos', :vcr do
    expect(channel_search).to be_a(Hash)
    expect(channel_search[:results]).to be_a(Array)

    first_hit = channel_search[:results].first
    expect(first_hit).to be_a(Hash)

    expect(first_hit[:alt_description]).to be_a String
    expect(first_hit[:urls][:full]).to be_a String
  end
end
