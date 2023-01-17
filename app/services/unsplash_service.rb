class UnsplashService
  def self.conn
    Faraday.new(url: 'https://api.unsplash.com') do |f|
      f.params['client_id'] = ENV['unsplash_access_key']
    end
  end

  def self.photo_search(query)
    response = conn.get('/search/photos') do |f|
      f.params['query'] = "#{query}"
    end
    JSON.parse(response.body, symbolize_names: true)
  end
end
