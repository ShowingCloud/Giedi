Rails.application.routes.draw do

  get 'contacts/index'

  root to: 'home#index'
  get 'activities/index'
  get 'services/index'
  match '*path', via: :all, to: 'home#error_404'
end
