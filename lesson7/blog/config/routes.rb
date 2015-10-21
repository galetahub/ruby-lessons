Rails.application.routes.draw do
  mount API::Engine => "/api"

  resources :tags, only: [:show]  
  root 'welcome#index'
end