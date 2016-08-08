Rails.application.routes.draw do

  namespace :admin do
    resources :admin_users
    resources :service_permissions
    resources :service_rules
    resources :users
      root to: "admin_users#index"
  end

  devise_for :admin_users, path: 'admin', skip: :registrations

  post 'password_resets_by_phone' => 'password_resets#create_by_phone'
  get 'password_resets_by_phone' => 'password_resets#new_by_phone'
  patch 'password_resets_by_phone' => 'password_resets#update_by_phone'
  resources :password_resets,     only: [:new, :create, :edit, :update]

  resources :phone_verifications,only: [:new, :create]
  get 'users/new_by_phone' => 'users#new_by_phone'
  post 'users/new_by_phone' => 'users#create_by_phone'
  get 'users/resend_email' => 'users#resend_email'

  resources :users, only: [:edit, :new, :create, :update, :show]
  resources :users, only: [:update, :show], path:"user_infos" do
    resource :user_extra, only:[:create, :show]
  end

  get 'profile' => 'users#profile'
  get 'profile/phone' => 'users#add_phone'
  get 'profile/email' => 'users#add_email'
  get 'profile/avatar' => 'users#edit_avatar'
  post 'profile/add_email' => 'users#add_email_sent'
  get 'profile/password' => 'users#edit_password'

  resources :email_confirmations, only: [:edit]
  mount CASino::Engine => '/', :as => 'casino'
  mount RuCaptcha::Engine => '/rucaptcha'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
