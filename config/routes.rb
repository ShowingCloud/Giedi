Rails.application.routes.draw do

  root to: 'home#index'
  get 'about/index'
  get 'projects/index'

end
