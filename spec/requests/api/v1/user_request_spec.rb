require 'rails_helper'

RSpec.describe 'Users', type: :request do
  describe 'Users API endpoint' do
    let(:user_params) { { name: 'Jomby', email: 'Jomby@gmail.com' } }
    context '- happy path -' do
      it 'can create a new user' do
        headers = { 'CONTENT_TYPE' => 'application/json' }
        post '/api/v1/users', headers: headers, params: JSON.generate(user: user_params)
        created_user = User.last

        expect(response).to be_successful
        expect(response.status).to eq(201)

        expect(created_user.name).to eq(user_params[:name])
        expect(created_user.email).to eq(user_params[:email])
        expect(created_user.api_key).to be_a String
        expect(created_user.api_key.count).to_not eq(0)

        body = response.body
        expect(body).to be_a Hash
        expect(body.keys).to eq([:data])
        expect(body[:data]).to be_a Hash
        expect(body[:data].keys).to eq(%i[type id attributes])
        expect(body[:data][:type]).to eq('user')
        expect(body[:data][:id]).not_to match(/\D/)
        expect(body[:data][:attributes].keys).to eq(%i[name email api_key])
        body[:data][:attributes].each do |_k, v|
          expect(v).to be_a(String)
        end
      end
    end

    context '- sad path -' do
      it 'doesnt create a new user if already used email' do
        create(:user, name: 'Feybo', email: 'Jomby@gmail.com')
        headers = { 'CONTENT_TYPE' => 'application/json' }
        post '/api/v1/users', headers: headers, params: JSON.generate(user: user_params)
        created_user = User.last

        # expect(response).not_to be_successful
        # expect(response.status).to eq(403)
        expect(created_user.name).not_to eq('Jomby')
        expect(created_user.name).to eq('Feybo')
        expect(created_user.email).to eq(user_params[:email])
        expect(User.all.count).to eq(1)

        expect(response.status).to eq(200)

        expect(response.body.keys).to eq([:data])
        expect(response.body[:data].keys).to eq([:error])
      end
    end
  end
end
