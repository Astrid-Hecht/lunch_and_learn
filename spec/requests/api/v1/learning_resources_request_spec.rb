require 'rails_helper'

RSpec.describe 'Learning Resources', type: :request do
  describe 'Resources by Single Country API endpoint' do
    context 'valid search country renders' do
      it 'with correctly serialized data and no extra fields', :vcr do
        get '/api/v1/learning_resources?country=Mexico'

        parsed_response = JSON.parse(response.body, symbolize_names: true)

        expect(response.status).to eq(200)
        expect(parsed_response).to_not be_empty

        expect(parsed_response.keys).to eq([:data])

        resource = parsed_response[:data]

        expect(resource).to be_a Hash

        expect(resource.keys).to eq(%i[id type attributes])

        expect(resource[:attributes].keys).to eq(%i[country video images])

        expect(resource[:id]).to be_nil
        expect(resource[:type]).to eq('learning_resource')
        expect(resource[:attributes]).to be_a Hash

        expect(resource[:attributes][:country]).to be_a(String)

        expect(resource[:attributes][:video]).to be_a(Hash)
        expect(resource[:attributes][:video].keys).to eq(%i[title youtube_video_id])

        expect(resource[:attributes][:images]).to be_a(Array)
        expect(resource[:attributes][:images].first).to be_a(Hash)
        expect(resource[:attributes][:images].first.keys).to eq(%i[url alt_tag])
        expect(resource[:attributes][:images].first[:alt_tag]).to be_a String
        expect(resource[:attributes][:images].first[:url]).to be_a String
      end
    end

    context 'renders error' do
      it 'if no search search parameters', :vcr do
        get '/api/v1/learning_resources'

        parsed_response = JSON.parse(response.body, symbolize_names: true)

        expect(response).not_to be_successful
        expect(response.status).to eq(400)

        error = parsed_response[:data]

        expect(error[:id]).to be_nil
        expect(error[:type]).to eq('error')
        expect(error[:attributes]).to eq({ status: 400, msg: "Missing or invalid parameters" })
      end

      it 'if country is invalid', :vcr do
        get '/api/v1/learning_resources?country=Globglorbgorb'

        parsed_response = JSON.parse(response.body, symbolize_names: true)

        expect(response).not_to be_successful
        expect(response.status).to eq(404)

        error = parsed_response[:data]

        expect(error[:id]).to be_nil
        expect(error[:type]).to eq('error')
        expect(error[:attributes]).to eq({ status: 404, msg: 'Country not found' })

      end
    end

    context 'renders learning resource object with empty vid and/or imgs attributes' do
      it 'if country has no matching resources', :vcr do
        get '/api/v1/learning_resources?country=Niue'

        parsed_response = JSON.parse(response.body, symbolize_names: true)

        expect(response.status).to eq(200)

        expect(parsed_response.keys).to eq([:data])

        resource = parsed_response[:data]

        expect(resource.keys).to eq(%i[id type attributes])

        expect(resource[:attributes].keys).to eq(%i[country video images])

        expect(resource[:id]).to be_nil
        expect(resource[:type]).to eq('learning_resource')
        expect(resource[:attributes]).to be_a Hash

        expect(resource[:attributes][:country]).to be_a(String)

        expect(resource[:attributes][:video]).to be_a(Hash)
        expect(resource[:attributes][:video].keys).to eq([])

        expect(resource[:attributes][:images]).to be_a(Array)
        expect(resource[:attributes][:images].first).to be_a(Hash)
        expect(resource[:attributes][:images].first.keys).to eq(%i[url alt_tag])
        expect(resource[:attributes][:images].first[:alt_tag]).to be_a String
        expect(resource[:attributes][:images].first[:url]).to be_a String
      end
    end
  end
end
