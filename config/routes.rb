Rails.application.routes.draw do


  root to: 'home#index'

  devise_for :users, skip: [:sessions], controllers: {cas_sessions: 'our_cas_sessions'}
  devise_scope :user do
    get "sign_in", to: "auth/cas_sessions#new"
    get "sign_up", to: "auth/cas_sessions#sign_up"
    delete "sign_out", to: "auth/cas_sessions#destroy"
  end
  get '/commonweal', to: 'commonweal#index'
  get '/courses', to: 'courses#index'
  get '/courses/dome', to: 'courses#dome'
  post '/courses/apply_group', to: 'courses#apply_group'
  get '/courses/schedule', to: 'courses#schedule'
  post '/courses/sign_in', to: 'courses#sign_in'
  get '/courses/:id', to: 'courses#show'
  get '/courses/lesson_test/:id', to: 'courses#lesson_test'
  post '/courses/check_lesson_test', to: 'courses#check_lesson_test'
  get '/courses/community/:id', to: 'courses#community'
  get '/courses/discuss/:id', to: 'courses#discuss'
  post '/courses/discuss_post', to: 'courses#discuss_post'
  get '/courses/lesson_ware/:id', to: 'courses#lesson_ware'
  get 'test' => 'test#index'

  resources :likes
  post '/courses/upload_opus', to: 'courses#upload_opus'

  get '/news', to: 'news#index'
  get '/news/:id', to: 'news#show'

  namespace :kindeditor do
    post '/upload' => 'assets#create'
    get '/filemanager' => 'assets#list'
  end

  # -----------------------------------------------------------
  # Api
  # -----------------------------------------------------------

  namespace :api do
    namespace :v1 do
      resources :users do
        collection do
          get :get_districts
          get :get_schools
        end
      end
    end
  end

  # -----------------------------------------------------------
  # Admin
  # -----------------------------------------------------------

  get '/admin/' => 'admin#index'

  namespace :admin do |admin|

    resources :accounts, only: [:new, :index, :create, :destroy] do
      collection do
        get :change_password
        post :change_password_post
      end
    end
    get '/checks/teachers', to: 'checks#teachers'
    get '/checks/teacher_list', to: 'checks#teacher_list'
    get '/checks/hackers', to: 'checks#hackers'
    get '/checks/hacker_list', to: 'checks#hacker_list'
    post '/checks/review_teacher', to: 'checks#review_teacher'
    post '/checks/review_hacker', to: 'checks#review_hacker'
    get '/checks/students', to: 'checks#students'
    post '/checks/review_students', to: 'checks#review_students'
    get '/checks/opus', to: 'checks#opus'
    post '/checks/review_opus', to: 'checks#review_opus'
    resources :admins
    resources :users
    resources :districts
    resources :schools
    resources :roles
    resources :courses do
      collection do
        post :add_attr_star
        get :get_lessons
      end
    end
    resources :course_stars
    resources :groups do
      collection do
        post :add_course
        post :delete_course
        get :add_schedule
        post :add_schedule
        get :get_schedule
        post :delete_schedule
        post :update_schedule
        get :students
        get :lesson_test_result
      end
    end
    resources :lessons do
      collection do
        get :add_test
      end
    end
    resources :lesson_tests
    resources :photos
    resources :news do
      resources :images, :only => [:create, :destroy, :edit, :new] do
        collection do
          post :update_image
        end
      end
    end
    resources :consults
  end
  mount ActionCable.server => '/cable'

  # -----------------------------------------------------------
  # User
  # -----------------------------------------------------------

  get 'user' => redirect('/user/preview')
  get 'user/preview' => 'user#preview', as: 'user_preview'
  match 'user/profile' => 'user#profile', as: 'user_profile', via: [:get, :post]
  match 'user/passwd' => 'user#passwd', as: 'user_passwd', via: [:get, :post]
  match 'user/mobile' => 'user#mobile', as: 'user_mobile', via: [:get, :post]
  match 'user/email' => 'user#email', as: 'user_email', via: [:get, :post]
  match 'user/reset_mobile' => 'user#reset_mobile', as: 'user_reset_mobile', via: [:get, :post]
  match 'user/reset_email' => 'user#reset_email', as: 'user_reset_email', via: [:get, :post]
  match 'user/consult' => 'user#consult', as: 'user_consult', via: [:get, :post]
  get '/user/get_schools' => 'user#get_schools', as: 'user_get_schools'
  get '/user/get_districts' => 'user#get_districts', as: 'user_get_districts'
  match 'user/notifications' => 'user#notifications', as: 'user_notifications', via: [:get]
  get '/user/notify' => 'user#notify_show'
  get '/user/opus', to: 'user#opus'

  match '*path', via: :all, to: 'home#error_404'
end
