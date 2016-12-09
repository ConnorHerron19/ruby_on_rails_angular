Rails.application.routes.draw do

  root :to => 'main#index'

  namespace :api do
    resources :users
    resources :locations
    resources :bookings
  end

  post 'api/users/logout', to: 'api/users#logout'
  post 'api/users/status', to: 'api/users#status'
  post 'api/users/login', to: 'api/users#login'
  post 'api/users/status', to: 'api/users#status'
  post 'api/bookings/accept', to: 'api/bookings#accept'
  post 'api/bookings/start_ride', to: 'api/bookings#start_ride'
  post 'api/bookings/end_ride', to: 'api/bookings#end_ride'
  post 'api/locations/location_set', to: 'api/locations#location_set'
end
