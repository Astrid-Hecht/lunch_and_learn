require 'rails_helper'

RSpec.describe 'Recipes', type: :request do
  describe 'Search by Country API endpoint' do
    context 'returns an array of results' do
      it 'with correctly serialized data' do
        get '/api/v1/recipies?country=Mexico'

        parsed_response = JSON.parse(response.body.gsub('null', 'nil'), symbolize_names: true)

        expect(response.status).to eq(200)
        expect(parsed_response).to_not be_empty

        expect(parsed_response).to have_key :data
        expect(parsed_response[:data]).to be_an Array

        recipe = parsed_response[:data]

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
    end
  end
end
