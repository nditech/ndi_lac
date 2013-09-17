NdiDatabase::Application.routes.draw do
  devise_for :users
  root 'dashboard#index'
  
  match "/profile", to: 'users#profile', as: 'user_profile', via: :get
  
  resources :contacts
  resources :organizations
  resources :users
  resources :countries, only: [:show]
  resources :contacts_search, only: [:create]
  resources :export_excel, only: [:create]
end
