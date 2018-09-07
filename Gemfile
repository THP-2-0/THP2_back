# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby File.read('./.ruby-version')

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.0'
# Use postgresql as the database for Active Record
gem 'pg', '>= 0.18', '< 2.0'
# Use Puma as the app server
gem 'puma', '~> 3.11'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

# Extracting JSON serialialization in its own class
gem 'active_model_serializers', '~> 0.10.0'

# Auth with tokens for an API
gem 'devise_token_auth', '~> 0.1', github: 'denispasin/devise_token_auth'
# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
gem 'rack-cors'

gem "interactor", "~> 3.0"
gem 'interactor-contracts'
gem "interactor-rails"
gem 'kaminari'
gem "pundit"
gem "sidekiq"

group :production do
  gem 'lograge'
  gem "logstash-event"
  gem 'logstash-logger'
  gem 'rack-attack'
  gem 'rack-timeout'
  gem 'sentry-raven'
  gem "skylight"
end

group :development, :test do
  gem 'dotenv-rails'
  gem 'factory_bot_rails'
  gem 'pry-byebug'
  gem 'rspec-rails'
end

group :development do
  gem 'annotate', require: false
  gem 'guard', require: false
  gem 'guard-annotate', require: false
  gem 'guard-rspec', require: false
  gem 'guard-rubocop', require: false
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'pry-rails'
  gem 'rubocop', require: false
  gem 'rubocop-rspec', require: false
  gem 'solargraph', require: false
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'faker'
  gem "nyan-cat-formatter"
  gem "rspec_in_context"
  gem "rspec_junit_formatter"
  gem 'shoulda-matchers', '~> 3.1'
  gem 'simplecov', require: false
end
