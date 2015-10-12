Rails.application.routes.draw do
  resources :tags, only: [:show]  
  root 'welcome#index'
end