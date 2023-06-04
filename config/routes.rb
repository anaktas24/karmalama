Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }

  devise_scope :user do
    get '/sign_up/personal_info', to: 'users/registrations#personal_info', as: :new_user_registration_personal_info
    post '/sign_up/personal_info', to: 'users/registrations#create_personal_info', as: :create_user_registration_personal_info
    get '/sign_up/photo', to: 'users/registrations#photo', as: :new_user_registration_photo
    post '/sign_up/photo', to: 'users/registrations#create_photo', as: :create_user_registration_photo
    get '/sign_up/account_details', to: 'users/registrations#account_details', as: :new_user_registration_account_details
    post '/sign_up/account_details', to: 'users/registrations#create_account_details', as: :create_user_registration_account_details
  end




  root to: "pages#home"
  get '/my_bookings', to: 'bookings#my_bookings'
  get '/profile', to: 'pages#profile'
  patch '/profile', to: 'pages#update_profile'
  get '/my_assignments', to: 'pages#my_assignments'





  resources :listings do
    resources :bookings do
      member do
        patch '/confirm', to: 'bookings#confirm'
        patch '/reject', to: 'bookings#reject'
      end
    end
  end
end
