Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }

  root to: "pages#home"

  # User
  get '/profile', to: 'users#profile', as: 'profile'
  get '/profile/edit', to: 'users#edit', as: 'edit'
  patch '/profile', to: 'users#update', as: 'update'
  delete '/users/:id/delete', to: 'users#destroy', as: 'delete_user'

  # Signup
  get '/users/step1', to: 'users/registrations#step1', as: 'step1_user_registration'
  post '/users/step1', to: 'users/registrations#process_step1', as: 'process_step1_user_registration'
  get '/users/step3', to: 'users/registrations#step3', as: 'step3_user_registration'

  # Admin
  # namespace :admin, constraints: { role: :admin } do
  #   get '/index', to: 'admin#index', as: 'admin_dashboard'
  #   get '/listings/new', to: 'admin#new_listing', as: 'new_listing'
  #   post '/listings', to: 'admin#create_listing', as: 'create_listing'
  #   get '/listings/:id/edit', to: 'admin#edit_listing', as: 'edit_listing'
  #   patch '/listings/:id', to: 'admin#update_listing', as: 'update_listing'
  #   delete '/listings/:id', to: 'admin#destroy_listing', as: 'destroy_listing'
  # end

  # Listing
  resources :listings, only: [:index, :show] do
    resources :bookings, only: [:index, :create, :update, :destroy, :show] do
      member do
        patch 'confirm'
        patch 'reject'
      end
    end
  end

  get 'my_bookings', to: 'bookings#my_bookings', as: 'my_bookings'
  get 'my_bookings/:id', to: 'bookings#show', as: 'booking'
  delete '/my_bookings/:id', to: 'bookings#destroy', as: 'destroy_booking'
end
