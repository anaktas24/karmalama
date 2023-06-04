Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'registrations' }

  devise_scope :user do
    get '/sign_up/personal_info', to: 'registrations#personal_info', as: :personal_info_registration
    post '/sign_up/create_personal_info', to: 'registrations#create_personal_info', as: :create_personal_info_registration
    get '/sign_up/photo', to: 'registrations#photo', as: :photo_registration
    post '/sign_up/create_photo', to: 'registrations#create_photo', as: :create_photo_registration
    get '/sign_up/account_details', to: 'registrations#account_details', as: :account_details_registration
    post '/sign_up/create_account_details', to: 'registrations#create_account_details', as: :create_account_details_registration
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
