require 'rails_helper'

RSpec.describe YoutubeService do
  let(:channel_search) { YoutubeService.channel_search("China", '@MrHistory1') }

  it 'can search videos on a specific channel', :vcr do
    expect(channel_search).to be_a(Hash)
    expect(channel_search[:items]).to be_a(Array)

    first_hit = channel_search[:hits].first
    expect(first_hit).to be_a(Hash)

    expect(first_hit[:id][:channelId]).to eq('@MrHistory1')
    expect(first_hit[:id][:videoId]).to be_a(String)
    expect(first_hit[:snippet][:title]).to be_a(String)
  end
end
