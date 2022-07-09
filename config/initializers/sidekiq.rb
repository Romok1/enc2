require 'sidekiq'
require 'sidekiq-status'

def add_redis_url_to_config config
  unless Rails.env.development?
    config.redis = {
      url: Rails.application.credentials.dig(
        Rails.env.to_sym, :redis_url
      )
    }
  end
end

Sidekiq.configure_client do |config|
  # accepts :expiration (optional)
  Sidekiq::Status.configure_client_middleware config, expiration: 5.minutes

  add_redis_url_to_config(config)
end

Sidekiq.configure_server do |config|
  # accepts :expiration (optional)
  Sidekiq::Status.configure_server_middleware config, expiration: 5.minutes

  # accepts :expiration (optional)
  Sidekiq::Status.configure_client_middleware config, expiration: 5.minutes

  add_redis_url_to_config(config)
end