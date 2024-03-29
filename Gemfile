source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.2'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails', branch: 'main'
gem 'rails', '~> 6.1.6'
# Use postgresql as the database for Active Record
gem 'pg', '~> 1.1'
# Use Puma as the app server
gem 'puma', '~> 5.0'
# Use SCSS for stylesheets
gem 'sass-rails', '>= 6'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '~> 5.0'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.4', require: false

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem "rspec-rails", "~> 5.1"
  gem "rails-controller-testing", "~> 1.0"
  gem "factory_bot_rails", "~> 6.2"
end

gem "slim-rails", "~> 3.5"
gem "aws-sdk-s3", require: false
gem "octicons_helper", "~> 17.2"
gem "cocoon", "~> 1.2"
gem 'active_storage_validations'
gem "redis-rails", "~> 5.0"

# get your Rails variables in your js
gem "gon", "~> 6.4"

# Authentication & authorization
gem "devise", "~> 4.8"
gem "omniauth", "~> 2.1"
gem "omniauth-rails_csrf_protection", "~> 1.0"
gem "omniauth-github", "~> 2.0"
gem "omniauth-vkontakte", "~> 1.8"
gem "cancancan", "~> 3.4"

gem "letter_opener", "~> 1.8"

# REST API
gem "doorkeeper", "~> 5.6"
gem "active_model_serializers", "~> 0.10.13"

# Optimized json
gem "oj", "~> 3.13"

# Background jobs
gem "sidekiq", "~> 6.5"
gem 'sinatra', require: false
gem "whenever", "~> 1.0", require: false

# search with sphinx
gem "mysql2", "~> 0.5.4"
gem "thinking-sphinx", "~> 5.4"

# Deploy
gem "unicorn", "~> 6.1"

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 4.1.0'
  # Display performance information such as SQL time and flame graphs for each request in your browser.
  # Can be configured to work on production as well see: https://github.com/MiniProfiler/rack-mini-profiler/blob/master/README.md
  gem 'rack-mini-profiler', '~> 2.0'
  gem 'listen', '~> 3.3'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'

  # Deploy
  gem 'capistrano', '~> 3.11', require: false  
  gem 'capistrano-rails', '~> 1.4', require: false
  #gem 'capistrano-passenger', '~> 0.2.0', require: false
  gem "capistrano3-unicorn", "~> 0.2.1", require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano-sidekiq', require: false
  #gem 'capistrano-rbenv', '~> 2.1', '>= 2.1.4', require: false
  gem 'capistrano-rvm', require: false
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 3.26'
  gem 'selenium-webdriver', '>= 4.0.0.rc1'
  gem "capybara-email", "~> 3.0"
  # Easy installation and use of web drivers to run system tests with browsers
  gem 'webdrivers'
  gem "shoulda-matchers", "~> 5.1"  
  gem "launchy", "~> 2.5"
  gem "database_cleaner-active_record", "~> 2.0"
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
