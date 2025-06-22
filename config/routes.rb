Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Devise routes for authentication
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }

  # Google Drive Clone routes
  root 'dashboard#index'
  
  # Dashboard
  get 'dashboard', to: 'dashboard#index'
  get 'search', to: 'dashboard#search'
  get 'shared', to: 'dashboard#shared', as: :shared
  get 'starred', to: 'dashboard#starred', as: :starred
  get 'trash', to: 'dashboard#trash', as: :trash
  
  # Folders
  resources :folders do
    member do
      patch :star
      patch :unstar
      get :share
      get :dropdown
    end
    resources :folder_shares, only: [:create, :destroy]
  end
  
  # Documents
  resources :documents do
    member do
      get :download
      patch :star
      patch :unstar
      get :share
      get :dropdown
    end
    collection do
      get :bulk_upload
      post :process_bulk_upload
      get :debug
    end
    resources :document_shares, only: [:create, :destroy]
  end
  
  # API routes for AJAX requests
  namespace :api do
    namespace :v1 do
      resources :folders, only: [:index, :show] do
        member do
          patch :star
          patch :unstar
        end
      end
      
      resources :documents, only: [:index, :show] do
        member do
          patch :star
          patch :unstar
        end
      end
      
      get 'search', to: 'search#index'
    end
  end

  get 'settings', to: 'settings#edit'
  patch 'settings', to: 'settings#update'
end
