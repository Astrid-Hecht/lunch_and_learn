class YoutubeService
  def self.conn
    Faraday.new(url: "https://www.googleapis.com/youtube/v3") do |f|
      f.params['key'] = ENV['youtube_data_key']
    end
  end

  def self.channel_vids_search(query, channel_id)
    response = conn.get("/search") do |f|
      f.params['part'] = 'snippet'
      f.params['type'] = 'video'
      f.params['videoEmbeddable'] = 'true'
      f.params['channelId'] = "#{channel_id}"
      f.params['q'] = "#{query}"
    end

    JSON.parse(response.body, symbolize_names: true)
  end
end
