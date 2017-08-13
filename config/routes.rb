Rails.application.routes.draw do

  devise_for :users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  root to: 'visitors#index'
  #resources :users
  namespace :api do #namespace :api, path: "", constraints: {:subdomain => "api"} do
    namespace :v1 do
      post 'authenticate', to: 'authentication#authenticate'
    end
  end


end