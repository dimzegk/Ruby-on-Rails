Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: "registrations" }
  root to: "pages#index"

  devise_scope :user do
    get "login",  to: "devise/sessions#new"
    get "signup", to: "devise/registrations#new"
  end

  resources :posts do
    collection do
      get :hobby
      get :study
      get :team
    end
  end

  namespace :private do
    resources :conversations, only: [ :create ] do
      member do
        post :close
        get  :open
      end

      resources :messages, only: [ :index, :create ]
    end
  end

namespace :group do
  resources :conversations do
    member do
      post :close
      post :open
    end
    resources :messages, only: [ :index, :create ]  
  end
end


  resources :contacts, only: [ :create, :update, :destroy ]

  resources :messengers, only: [ :index ] do
    collection do
      get :get_private_conversation
      get :get_group_conversation
      get :open_messenger
    end
  end
  get "messenger",          to: "messengers#index" # σύντομο alias
  get "open_messenger",     to: "messengers#open_messenger",     as: :open_messenger
  get "get_private_conversation", to: "messengers#get_private_conversation", as: :get_private_conversation
  get "get_group_conversation",   to: "messengers#get_group_conversation",   as: :get_group_conversation

  mount ActionCable.server => "/cable"
end
