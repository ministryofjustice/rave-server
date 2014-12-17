Rails.application.routes.draw do
  use_doorkeeper
  devise_for :users

  resources :scans
end
