class YoutubeFacade
  def self.mr_history_search(query)
    mr_hist_channel_id = 'UCluQ5yInbeAkkeCndNnUhpw'

    result = YoutubeService.channel_vids_search(query, mr_hist_channel_id)[:items].first

    { title: result[:snippet][:title], youtube_video_id: result[:id][:videoId] }
  end
end
