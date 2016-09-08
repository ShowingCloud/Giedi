Rails.application.routes.draw do
  root to: 'home#index'
  devise_for :users, skip: [:sessions], controllers: {cas_sessions: 'our_cas_sessions'}
  devise_scope :user do
    get "sign_in", to: "auth/cas_sessions#new"
    delete "sign_out", to: "auth/cas_sessions#destroy"
  end
end
