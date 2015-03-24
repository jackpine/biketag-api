require 'rails_helper'

describe 'game requests' do
  describe 'GET /api/v1/games/1/current_spot' do
    context 'with a set up game' do
      before do
        require Rails.root + 'db/seeds.rb'
        Seeds.seed!
      end
      let(:spot_id) { Seeds.lucile_spot.id }

      it 'returns the current spot' do

        get '/api/v1/games/1/current_spot.json'
        expect(response).to be_success

        actual_response = JSON.parse(response.body)

        expected_response = JSON.parse({
          spot:  {
            id: spot_id,
            url: "http://www.example.com/api/v1/games/1/spots/#{spot_id}.json",
            user_id: 1, #TODO user system not implented yet.
            user_name: "michael", #TODO user system not implented yet.
            image_url: sprintf('http://localhost:3000/uploads/spots/images/000/000/%03d/medium/952_lucile.jpg?1426555184', spot_id),
            created_at: Seeds.lucile_spot.created_at
          }
        }.to_json)

        # Image URL has to be checked separately
        expected_image_url = expected_response['spot'].delete('image_url')
        actual_image_url = actual_response['spot'].delete('image_url')

        expect(actual_response["spot"]).to eq(expected_response["spot"])

        actual_image_url_without_query_parameters = actual_image_url.split("?")[0]
        expected_image_url_without_query_parameters = expected_image_url.split("?")[0]
        expect(actual_image_url_without_query_parameters).to match(expected_image_url_without_query_parameters)
      end
    end
  end
end
