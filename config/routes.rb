NdiDatabase::Application.routes.draw do
  devise_for :users
  root 'contacts#index'
  
  match "/profile", to: 'users#profile', as: 'user_profile', via: :get
  
  resources :contacts
  resources :organizations
  resources :users
  resources :countries, only: [:show]
  resources :contacts_search, only: [:create]
  resources :export_excel, only: [:create]
  resources :export_pdf, only: [:create]
  resources :import_excel, only: [:create]
  resources :reports do
    resource :export_pdf, only: [:create], controller: 'export_pdf'
    resource :export_excel, only: [:create], controller: 'export_excel'
    resource :export_docx, only: [:create], controller: 'export_docx'
  end
end
