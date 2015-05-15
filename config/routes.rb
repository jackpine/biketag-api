Rails.application.routes.draw do

  devise_for :users

  # We don't have any views to auth users yet
  # - only the sessions/api key exchange
  # devise_for :users
  namespace 'api' do
    namespace 'v1' do
      resources :api_keys, only: [:create], defaults: { format: :json }

      resources :games, only: [:show, :index], defaults: { format: :json } do
        member do
          get :current_spot
        end
      end
      resources :spots, only: [:create, :show, :index], defaults: { format: :json }
      resources :guesses, only: [:create, :show, :index], defaults: { format: :json }
    end
  end

  root to: "pages#home"

end
