class CountryService
  def self.list_countries
    response = Faraday.get("https://restcountries.com/v2/all")

    JSON.parse(response.body, symbolize_names: true)
  end
end
