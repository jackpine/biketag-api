json.url api_v1_guess_url(1, guess.spot, guess, format: :json)
json.extract! guess, :id, :created_at, :correct, :location
