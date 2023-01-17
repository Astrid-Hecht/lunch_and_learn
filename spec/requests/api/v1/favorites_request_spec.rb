require 'rails_helper'

RSpec.describe 'Favorites', type: :request do
  describe 'Favorites API endpoint' do
    context '- happy path -' do
      it 'can create a new favorite' do
        user = create(:user)
        fav_params = { api_key: user.api_key, country: 'Sealand', recipe_link: 'www.link.com',
                       recipe_title: 'Recipe No 12121' }
        headers = { 'CONTENT_TYPE' => 'application/json' }

        post '/api/v1/favorites', headers: headers, params: JSON.generate(fav_params)
        created_fav = Favorite.last

        expect(response).to be_successful
        expect(response.status).to eq(201)

        expect(created_fav.api_key).to eq(fav_params[:api_key])
        expect(created_fav.country).to eq(fav_params[:country])
        expect(created_fav.recipe_link).to eq(fav_params[:recipe_link])
        expect(created_fav.recip_title).to eq(fav_params[:recip_title])

        body = JSON.parse(response.body, symbolize_names: true)

        expect(body).to be_a Hash
        expect(body.keys).to eq([:success])
        expect(body[:success]).to eq('Favorite added successfully')
      end
    end
  end
end
