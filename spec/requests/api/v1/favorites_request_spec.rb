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

        expect(created_fav.user).to eq(user)
        expect(created_fav.country).to eq(fav_params[:country])
        expect(created_fav.recipe_link).to eq(fav_params[:recipe_link])
        expect(created_fav.recipe_title).to eq(fav_params[:recipe_title])

        body = JSON.parse(response.body, symbolize_names: true)

        expect(body).to be_a Hash
        expect(body.keys).to eq([:success])
        expect(body[:success]).to eq('Favorite added successfully')
      end
    end

    context '- sad path -' do
      it 'wont create a new favorite when fields are missing' do
        user = create(:user)
        fav_params = { api_key: user.api_key, country: 'Sealand', recipe_link: 'www.link.com',
                       recipe_title: 'Recipe No 12121' }
        headers = { 'CONTENT_TYPE' => 'application/json' }

        post '/api/v1/favorites', headers: headers, params: JSON.generate(fav_params.delete(:country))
        post '/api/v1/favorites', headers: headers, params: JSON.generate(fav_params.delete(:recipe_link))
        post '/api/v1/favorites', headers: headers, params: JSON.generate(fav_params.delete(:recipe_title))

        created_fav = Favorite.last

        # expect(response).to be_successful
        # expect(response.status).to eq(201)

        expect(created_fav).to eq(nil)
        expect(Favorite.all.count).to eq(0)

        body = JSON.parse(response.body, symbolize_names: true)

        expect(body).to be_a Hash
        expect(body.keys).to eq([:data])
        expect(body[:data].keys).to eq([:error])
      end
      it 'wont create a new favorite when no matching api key' do
        user = create(:user)
        fav_params = { api_key: 'arbitrarystring', country: 'Sealand', recipe_link: 'www.link.com',
                       recipe_title: 'Recipe No 12121' }
        headers = { 'CONTENT_TYPE' => 'application/json' }

        post '/api/v1/favorites', headers: headers, params: JSON.generate(fav_params)

        created_fav = Favorite.last

        # expect(response).to be_successful
        # expect(response.status).to eq(201)

        expect(created_fav).to eq(nil)
        expect(Favorite.all.count).to eq(0)

        body = JSON.parse(response.body, symbolize_names: true)

        expect(body).to be_a Hash
        expect(body.keys).to eq([:data])
        expect(body[:data].keys).to eq([:error])
      end
    end
  end
end
