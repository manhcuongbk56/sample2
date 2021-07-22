source 'https://rubygems.org'

gem 'rails', '~> 6.1.3', '>= 6.1.3.1'
gem 'sqlite3', '~> 1.4'
gem 'sass-rails'
gem 'uglifier'
gem 'coffee-rails'
gem 'jquery-rails'
gem 'turbolinks'
gem 'jbuilder'
gem 'bcrypt'

group :local, :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
  gem 'pry-rails'
  gem 'uuid'
  gem 'factory_bot_rails' # http://rubydoc.info/gems/factory_girl/file/GETTING_STARTED.md
end

group :local, :development do
  # Use Capistrano for deployment
  gem 'capistrano-rails' # bundle exec cap install
  gem 'capistrano-rvm'
  gem 'capistrano-puma', require: false
end


group :development do
  gem 'web-console'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end

gem 'stripe'
gem 'config_service'
gem 'jquery-ui-rails'
gem 'bootstrap-sass'
gem 'autoprefixer-rails'
gem 'rest-client'

gem 'puma'

group :test do
  gem 'rspec-rails' # rails g rspec:install
  gem 'rails-controller-testing'
  gem 'database_cleaner'
  gem 'simplecov'
end

gem 'digest-sha3'
gem 'sidekiq'
gem 'rufus-scheduler'
