require 'rails_helper'

RSpec.describe 'Favorites', type: :request do
  describe 'Favorites API create endpoint' do
    context '- happy path -' do
      it 'can create a new favorite' do
        user = create(:user)
        fav_params = { api_key: user.api_key, country: 'Sealand', fav_link: 'www.link.com',
                       fav_title: 'fav No 12121' }
        headers = { 'CONTENT_TYPE' => 'application/json' }

        post '/api/v1/favorites', headers: headers, params: JSON.generate(fav_params)
        created_fav = Favorite.last

        expect(response).to be_successful
        expect(response.status).to eq(201)

        expect(created_fav.user).to eq(user)
        expect(created_fav.country).to eq(fav_params[:country])
        expect(created_fav.fav_link).to eq(fav_params[:fav_link])
        expect(created_fav.fav_title).to eq(fav_params[:fav_title])

        body = JSON.parse(response.body, symbolize_names: true)

        expect(body).to be_a Hash
        expect(body.keys).to eq([:success])
        expect(body[:success]).to eq('Favorite added successfully')
      end
    end

    context '- sad path -' do
      it 'wont create a new favorite when fields are missing' do
        user = create(:user)
        fav_params = { api_key: user.api_key, country: 'Sealand', fav_link: 'www.link.com',
                       fav_title: 'fav No 12121' }
        headers = { 'CONTENT_TYPE' => 'application/json' }

        post '/api/v1/favorites', headers: headers, params: JSON.generate(fav_params.delete(:country))
        post '/api/v1/favorites', headers: headers, params: JSON.generate(fav_params.delete(:fav_link))
        post '/api/v1/favorites', headers: headers, params: JSON.generate(fav_params.delete(:fav_title))

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
        _user = create(:user)
        fav_params = { api_key: 'arbitrarystring', country: 'Sealand', fav_link: 'www.link.com',
                       fav_title: 'fav No 12121' }
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

  describe 'Favorites API index endpoint' do
    context '- happy path -' do
      it 'can show all of a users favorites' do
        target_user = create(:user)
        unwanted_user = create(:user)
        create_list(:favorites, 4, user: target_user)
        create_list(:favorites, 2, user: unwanted_user)


        request_body = { api_key: target_user.api_key }

        headers = { 'CONTENT_TYPE' => 'application/json' }

        get '/api/v1/favorites', headers: headers, params: JSON.generate(request_body)

        expect(response).to be_successful
        expect(response.status).to eq(200)

        body = JSON.parse(response.body, symbolize_names: true)

        expect(body.keys).to eq([:data])
        expect(body[:data]).to be_an Array

        expect(body[:data].count).to eq(4)

        fav = body[:data].first

        expect(fav.keys).to eq(%i[id type attributes])

        expect(fav[:attributes].keys).to eq(%i[title url country image])

        expect(fav[:id]).to match(/\d/)
        expect(fav[:type]).to eq('favorite')
        expect(fav[:attributes]).to be_a Hash
        expect(fav[:attributes].keys).to eq([:recipe_title, :recipe_link, :country, :created_at])
        expect(fav[:attributes][:recipe_title]).to be_a(String)
        expect(fav[:attributes][:recipe_link]).to be_a(String)
        expect(fav[:attributes][:country]).to be_a(String)
        expect(fav[:attributes][:created_at]).to be_a(String)
      end

      it 'can renders an empty array if user hasnt saved and favs' do
        target_user = create(:user)
        unwanted_user = create(:user)
        create_list(:favorites, 2, user: unwanted_user)


        request_body = { api_key: target_user.api_key }

        headers = { 'CONTENT_TYPE' => 'application/json' }

        get '/api/v1/favorites', headers: headers, params: JSON.generate(request_body)

        expect(response).to be_successful
        expect(response.status).to eq(200)

        body = JSON.parse(response.body, symbolize_names: true)

        expect(body.keys).to eq([:data])
        expect(body[:data]).to be_an Array

        expect(body[:data].count).to eq(0)
      end
    end

    context '- sad path -' do
      it 'returns an error if api_key is invalid' do
        target_user = create(:user)
        unwanted_user = create(:user)
        create_list(:favorites, 4, user: target_user)
        create_list(:favorites, 2, user: unwanted_user)


        request_body = { api_key: "asdasgdrgertsdfc" }

        headers = { 'CONTENT_TYPE' => 'application/json' }

        get '/api/v1/favorites', headers: headers, params: JSON.generate(request_body)

        # expect(response).to be_successful
        # expect(response.status).to eq(404)

        body = JSON.parse(response.body, symbolize_names: true)

        expect(body.keys).to eq([:data])
        expect(body[:data]).to be_a Hash

        expect(body[:data].keys).to eq([:error])
      end
    end
  end
end
