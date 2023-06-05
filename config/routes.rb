Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }



  root to: "pages#home"
  get '/my_bookings', to: 'bookings#my_bookings'
  get '/profile', to: 'pages#profile'
  patch '/profile', to: 'pages#update_profile'
  get '/my_assignments', to: 'pages#my_assignments'

  get '/users/step1', to: 'users/registrations#step1', as: 'step1_user_registration'
  post '/users/step1', to: 'users/registrations#process_step1', as: 'process_step1_user_registration'
  # Replace the existing routes for step 2
  get '/users/step2', to: 'users/registrations#step2', as: 'step2_user_registration'
  post '/users/step2', to: 'users/registrations#process_step2', as: 'process_step2_user_registration'

  get '/users/step3', to: 'users/registrations#step3', as: 'step3_user_registration'
  post '/users/step3', to: 'users/registrations#process_step3', as: 'process_step3_user_registration'



  resources :listings do
    resources :bookings do
      member do
        patch '/confirm', to: 'bookings#confirm'
        patch '/reject', to: 'bookings#reject'
      end
    end
  end
end
