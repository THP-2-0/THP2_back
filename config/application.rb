# frozen_string_literal: true

require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"
# require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module THP2Back
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = true

    config.generators do |g|
      g.orm :active_record, primary_key_type: :uuid
    end

    config.active_job.queue_adapter = :sidekiq
    # TODO TEST ME
    # config.active_job.queue_name_prefix = "THP2_back_#{Rails.env}"
    ALLOWED_ORIGINS = [
      'http://localhost:8000',
      'http://0.0.0.0:8000',
      'http://127.0.0.1:8000',
      'http://localhost:8001',
      'http://0.0.0.0:8001',
      'http://127.0.0.1:8001',
      %r{\Ahttps://\S*\.thp2\.com\z},
      %r{\Ahttps://thp2-?\S*\.herokuapp\.com\z}
    ].freeze

    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins ALLOWED_ORIGINS
        resource '*', headers: :any, methods: :any, expose: ['uid', 'access-token', 'expiry', 'client']
      end
    end
  end
end
