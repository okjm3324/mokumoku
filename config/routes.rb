# frozen_string_literal: true

Rails.application.routes.draw do
  get 'relationships/create'
  get 'relationships/destory'
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
  get 'events/index'
  root 'events#index'
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
  get 'signup', to: 'users#new'
  post 'signup', to: 'users#create'
  post 'relationships/create/:id', to: 'relationships#create',  as: 'follow'
  post 'relationships/destroy/:id', to: 'relationships#destroy',  as: 'unfollow'

  resources :users, only: %i[new create show edit]
  resources :events do
    collection do
      get :future
      get :past
    end
    resource :attendance, only: %i[create destroy], module: :events
    resource :bookmark, only: %i[create destroy], module: :events
    resources :comments, only: %i[create destroy], module: :events
  end

  resources :notifications, only: %i[index show]
  namespace :notifications do
    resource :all_reads, only: %i[create]
  end

  namespace :mypage do
    root 'event_calendars#show'
    resource :event_calendar, only: %i[show]
    resources :notifications, only: %i[index]
    resource :notification_setting, only: %i[show update]
    resource :profile, only: %i[show update] do
      resource :avatar, only: %i[destroy], module: :profiles
    end
    resource :password_change, only: %i[show update]
  end

  namespace :api, defaults: { format: :json } do
    namespace :me do
      resources :events, only: %i[index]
    end
  end
end
