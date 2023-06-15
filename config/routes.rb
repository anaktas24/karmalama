Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }



  root to: "pages#home"
  get '/my_bookings', to: 'bookings#my_bookings'
  get '/my_assignments', to: 'pages#my_assignments'

  #User
  get '/profile', to: 'users#profile', as: 'profile'
  get '/profile/edit', to: 'users#edit', as: 'edit'
  patch '/profile', to: 'users#update', as: 'update'
  delete '/users/:id/delete', to: 'users#destroy', as: 'delete_user'



  #Signup
  get '/users/step1', to: 'users/registrations#step1', as: 'step1_user_registration'
  post '/users/step1', to: 'users/registrations#process_step1', as: 'process_step1_user_registration'
  get '/users/step3', to: 'users/registrations#step3', as: 'step3_user_registration'


  resources :listings, only: [:index, :show] do
    member do
      post 'apply'
    end
  end
end
