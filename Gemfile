source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 4.2.6'

# Use SCSS for stylesheets
gem 'sass-rails'#, '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier'#, '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
#gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'

gem 'sdoc', group: :doc#, '~> 0.4.0'

gem 'bcrypt'#, '~> 3.1.7'

gem 'pg'

# CAS SSO
gem 'casino', github: 'rbCAS/CASino'
gem 'casino-activerecord_authenticator', github: 'Bikeman18/dome-activerecord_authenticator'

# captcha
gem 'rucaptcha'

# phone validation
gem 'phonelib'

# background processing
gem 'sidekiq'

# file uploads
gem 'carrierwave'
gem 'mini_magick'

# delegated authentication
gem 'omniauth'
gem 'omniauth-github'
gem 'omniauth-qq'
gem 'omniauth-wechat-oauth2', github: 'yangsr/omniauth-wechat-oauth2'
gem 'omniauth-weibo-oauth2'

# json api
gem 'active_model_serializers'#, '~> 0.10.0'
gem 'jwt'

# redis
gem 'hiredis'
gem 'readthis'

# admin dashboard
gem 'activeadmin', github: 'activeadmin', tag: 'v1.4.3'
gem 'activeadmin_json_editor'#, '~> 0.0.6'
gem 'devise'

gem 'config'

gem 'httparty'

gem "puma"
gem 'thin'

# deploy
gem 'mina', require: false
gem 'mina-puma', require: false
gem 'mina-sidekiq', require: false

gem 'rack-cors', :require => 'rack/cors'

gem 'brakeman', :require => false

gem 'rack-mini-profiler', require: false


group :test do
  gem 'shoulda-matchers', require: false
  gem 'database_cleaner'
  gem 'faker'
  gem 'webmock'
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
  #gem 'rspec-rails'
  gem 'capybara'
  gem 'factory_girl_rails'#, "~> 4.0"
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console'#, '~> 2.0'
  gem 'better_errors'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'meta_request'
end

gem 'newrelic_rpm'
