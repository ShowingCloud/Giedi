Rails.application.routes.draw do

  root to: 'home#index'
  get 'activities/index'
  get 'services/index'

end
