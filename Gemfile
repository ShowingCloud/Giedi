source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 4.2.6'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
#gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'

gem 'sdoc', '~> 0.4.0', group: :doc

gem 'bcrypt', '~> 3.1.7'

gem 'pg'

#CAS SSO
gem 'casino', github: 'rbCAS/CASino'
gem 'casino-activerecord_authenticator',github:'Bikeman18/dome-activerecord_authenticator'

#captcha
gem 'rucaptcha'

#phone validation
gem 'phonelib'

#background processing
gem 'sidekiq'

#file uploads
gem 'carrierwave'
gem 'mini_magick'

#json api
gem 'active_model_serializers', '~> 0.10.0'
gem 'jwt'

#redis
gem 'readthis'
gem 'hiredis'

#admin dashboard
gem 'activeadmin', '~> 1.0.0.pre4'
gem 'activeadmin_json_editor', '~> 0.0.6'
gem 'devise'

gem 'config'

gem 'httparty'

gem "puma"

group :test do
  gem 'shoulda-matchers', require: false
  gem 'database_cleaner'
  gem 'faker'
  gem 'webmock'
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
  gem 'rspec-rails'
  gem 'capybara'
  gem 'factory_girl_rails', "~> 4.0"
  gem "codeclimate-test-reporter", require: nil
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'
  gem 'better_errors'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end
