require 'rails_helper'

RSpec.describe YoutubeFacade do
  let(:mr_history_search) { YoutubeFacade.mr_history_search("China") }
  
  context "#mr_history_search" do
    it 'extracts relevant data', :vcr do
      expect(mr_history_search).to be_an_instance_of(Hash)
      expect(mr_history_search.keys).to eq([:title, :youtube_video_id])

      expect(mr_history_search[:title]).to be_a(String)
      expect(mr_history_search[:youtube_video_id]).to be_a(String)
    end
  end
end