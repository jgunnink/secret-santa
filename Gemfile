source 'https://rubygems.org'

gem 'rails', "~> 4.2.1"

# Database & ORM
gem 'circular_list'
gem 'deep_cloneable'
gem 'paranoia'
gem 'pg', '~> 0.15'
gem 'ransack'

# Authentication & Authorization
gem 'devise'
gem 'cancancan'

# Presentation
gem 'active_link_to'
gem 'bootstrap-material-design'
gem 'bootstrap-sass'
gem 'bourbon'
gem 'cocoon'
gem 'coffee-rails'
gem 'foreman'
gem 'haml-rails'
gem 'jquery-rails'
gem 'jquery-timepicker-rails'
gem 'kaminari'
gem 'momentjs-rails'
gem 'neat'
gem 'normalize-rails'
gem 'page_title_helper'
gem 'sass-rails'
gem 'simple_form'
gem 'tachyons-rails'
gem 'turbolinks'
gem 'uglifier'

# Misc
gem 'sidekiq'
gem 'responders'
gem 'uri_query_merger'
gem 'tzinfo'
gem 'tzinfo-data'

group :development do
  gem 'better_errors'
  gem 'letter_opener'
  gem 'seed_helper'
  gem 'web-console'
end

group :development, :test do
  gem 'byebug'
  gem 'capybara'
  gem 'capybara-screenshot'
  gem 'factory_bot_rails'
  gem 'ffaker'
  gem 'rspec-rails'
  gem 'rspec_junit_formatter'
  gem 'simplecov', require: false
  gem 'simplecov-rcov', require: false
  gem 'webmock'
end

group :test do
  gem 'geckodriver-helper'
  gem 'database_cleaner'
  gem 'email_spec'
  gem 'shoulda-matchers'
  gem 'selenium-webdriver'
end

group :staging do
  # Enable "Staging" ribbon on top right corner
  gem 'rack-dev-mark'
end

group :staging, :production do
  gem 'bundler'
  gem 'puma'
  gem 'rails_12factor'
  gem 'exception_notification'
end
