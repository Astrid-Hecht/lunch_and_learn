require 'rails_helper'

RSpec.describe 'Recipes', type: :request do
  describe 'Search by Country API endpoint' do
    context 'valid search country renders an array of results' do
      it 'with correctly serialized data', :vcr do
        get '/api/v1/recipes?country=Mexico'

        parsed_response = JSON.parse(response.body, symbolize_names: true)

        expect(response.status).to eq(200)
        expect(parsed_response).to_not be_empty

        expect(parsed_response).to have_key :data
        expect(parsed_response[:data]).to be_an Array

        recipe = parsed_response[:data].first

        expect(recipe).to be_a Hash

        expect(recipe).to have_key :id
        expect(recipe[:id]).to be_nil

        expect(recipe).to have_key :type
        expect(recipe[:type]).to eq('recipe')

        expect(recipe).to have_key :attributes
        expect(recipe[:attributes]).to be_a Hash

        expect(recipe[:attributes]).to have_key :title
        expect(recipe[:attributes][:title]).to be_a(String)

        expect(recipe[:attributes]).to have_key :url
        expect(recipe[:attributes][:url]).to be_a(String)

        expect(recipe[:attributes]).to have_key :country
        expect(recipe[:attributes][:country]).to be_a(String)

        expect(recipe[:attributes]).to have_key :image
        expect(recipe[:attributes][:image]).to be_a(String)
      end

      it 'without extra data', :vcr do
        get '/api/v1/recipes?country=Mexico'

        parsed_response = JSON.parse(response.body, symbolize_names: true)

        expect(parsed_response.keys).to eq([:data])

        recipe = parsed_response[:data].first

        expect(recipe.keys).to eq(%i[id type attributes])

        expect(recipe[:attributes].keys).to eq(%i[title url country image])
      end
    end

    context 'no search term randomly generates country' do
      it 'and renders valid results with no extra data' do
        get '/api/v1/recipes'

        parsed_response = JSON.parse(response.body, symbolize_names: true)

        expect(response.status).to eq(200)

        expect(parsed_response.keys).to eq([:data])
        expect(parsed_response[:data]).to be_an Array

        recipe = parsed_response[:data].first

        expect(recipe.keys).to eq(%i[id type attributes])

        expect(recipe[:attributes].keys).to eq(%i[title url country image])

        expect(recipe[:id]).to be_nil
        expect(recipe[:type]).to eq('recipe')
        expect(recipe[:attributes]).to be_a Hash
        expect(recipe[:attributes][:title]).to be_a(String)
        expect(recipe[:attributes][:url]).to be_a(String)
        expect(recipe[:attributes][:country]).to be_a(String)
        expect(recipe[:attributes][:image]).to be_a(String)
      end
    end

    context 'renders empty array' do
      it 'if country is invalid' do
        get '/api/v1/recipes?country=Globglorbgorb'

        parsed_response = JSON.parse(response.body, symbolize_names: true)

        expect(response.status).to eq(200)

        expect(parsed_response.keys).to eq([:data])
        expect(parsed_response[:data].keys).to eq([:error])
      end

      it 'if country has is empty string' do
        get '/api/v1/recipes?country= '

        parsed_response = JSON.parse(response.body, symbolize_names: true)

        expect(response.status).to eq(200)

        expect(parsed_response.keys).to eq([:data])
        expect(parsed_response[:data]).to eq([])
      end

      it 'if country has no recipes' do
        get '/api/v1/recipes?country=Namibia'

        parsed_response = JSON.parse(response.body, symbolize_names: true)

        expect(response.status).to eq(200)

        expect(parsed_response.keys).to eq([:data])
        expect(parsed_response[:data]).to eq([])
      end
    end
  end
end
