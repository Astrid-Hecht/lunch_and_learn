require 'rails_helper'

RSpec.describe 'Users', type: :request do
  describe 'Users API endpoint' do
    let(:user_params) { { name: 'Jomby', email: 'JoMBy@gmail.com' } }
    context '- happy path -' do
      it 'can create a new user' do
        headers = { 'CONTENT_TYPE' => 'application/json' }

        post '/api/v1/users', headers: headers, params: JSON.generate(user_params)
        created_user = User.last

        expect(response).to be_successful
        expect(response.status).to eq(201)

        expect(created_user.name).to eq(user_params[:name])
        expect(created_user.email).to eq(user_params[:email].downcase)
        expect(created_user.api_key).to be_a String
        expect(created_user.api_key.length).to_not eq(0)

        body = JSON.parse(response.body, symbolize_names: true)
        expect(body).to be_a Hash
        expect(body.keys).to eq([:data])
        expect(body[:data]).to be_a Hash
        expect(body[:data].keys).to eq(%i[id type attributes])
        expect(body[:data][:type]).to eq('user')
        expect(body[:data][:id]).not_to match(/\D/)
        expect(body[:data][:attributes].keys).to eq(%i[name email api_key])
        body[:data][:attributes].each do |_k, v|
          expect(v).to be_a(String)
        end
      end

      it 'doesnt allow POST request to assign api_key' do
        headers = { 'CONTENT_TYPE' => 'application/json' }
        user_params[:api_key] = 'imahackerlol'
        post '/api/v1/users', headers: headers, params: JSON.generate(user_params)

        created_user = User.last

        expect(response).to be_successful
        expect(response.status).to eq(201)

        expect(created_user.api_key).not_to eq('imahackerlol')
        expect(User.all.count).to eq(1)
      end

      it 'lowercases email in db' do
        headers = { 'CONTENT_TYPE' => 'application/json' }
        user_params[:email] = 'JOMBY@GMAIL.com'

        post '/api/v1/users', headers: headers, params: JSON.generate(user_params)

        created_user = User.last

        expect(response).to be_successful
        expect(response.status).to eq(201)

        expect(created_user.email).not_to eq('JOMBY@GMAIL.com')
        expect(created_user.email).to eq('jomby@gmail.com')
        expect(User.all.count).to eq(1)
      end
    end

    context '- sad path -' do
      it 'doesnt create a new user if already used email' do
        create(:user, name: 'Feybo', email: 'jomby@gmail.com') # also shows that email uniqueness is case-insensitive
        headers = { 'CONTENT_TYPE' => 'application/json' }

        post '/api/v1/users', headers: headers, params: JSON.generate(user_params)

        created_user = User.last

        expect(response).not_to be_successful
        expect(response.status).to eq(400)

        expect(created_user.name).not_to eq('Jomby')
        expect(created_user.name).to eq('Feybo')
        expect(created_user.email).to eq(user_params[:email].downcase)
        expect(User.all.count).to eq(1)

        body = JSON.parse(response.body, symbolize_names: true)
        error = body[:data]

        expect(error[:id]).to be_nil
        expect(error[:type]).to eq('error')
        expect(error[:attributes]).to eq({ status: 400, msg: 'Bad request, check your parameters' })
      end

      it 'doesnt create a new user if invalid body passed in' do
        create(:user, name: 'Feybo')

        headers = { 'CONTENT_TYPE' => 'application/json' }

        post '/api/v1/users', headers: headers, params: JSON.generate(user_params.delete(:email))

        post '/api/v1/users', headers: headers, params: JSON.generate(user_params.delete(:name))

        user_params[:email] = '2asdfv'
        post '/api/v1/users', headers: headers, params: JSON.generate(user_params)

        user_params[:email] = ''
        user_params[:name] = ''
        post '/api/v1/users', headers: headers, params: JSON.generate(user_params)

        created_user = User.last

        expect(response).not_to be_successful
        expect(response.status).to eq(400)

        expect(created_user.name).not_to eq('Jomby')
        expect(created_user.name).to eq('Feybo')
        expect(User.all.count).to eq(1)

        body = JSON.parse(response.body, symbolize_names: true)
        error = body[:data]

        expect(error[:id]).to be_nil
        expect(error[:type]).to eq('error')
        expect(error[:attributes]).to eq({ status: 400, msg: 'Bad request, check your parameters' })
      end
    end
  end
end
