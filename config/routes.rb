Rails.application.routes.draw do
require 'sidekiq/web'
mount Sidekiq::Web => '/sidekiq'
# routes for api path 
namespace :api do
  namespace :v1 do
    resources :temperature, :only => [] do
      collection do
        post :reading # post api for saving data in reading
        get :stats # get api for reading data from stats 
      end
      member do
        get :reading # get api for reading data from reading
      end
    end
  end
end

end
