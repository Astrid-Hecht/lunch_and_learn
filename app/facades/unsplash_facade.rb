class UnsplashFacade
  def self.photo_search(query)
    results = UnsplashService.photo_search(query)[:results].limit(10)

    results.map! do |photo|
      photo[:url] = photo[:urls][:full]
      photo[:alt_tag] = photo[:alt_description]
      photo.select { |k, _v| %i[url alt_tag].include?(k) }
    end
  end
end
