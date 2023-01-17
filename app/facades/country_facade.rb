class CountryFacade
  def self.list_countries
    results = CountryService.list_countries

    results.map! do |country|
      country[:name]
    end
  end
end