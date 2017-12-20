config_redis = { url: 'redis://redis' }

Sidekiq.configure_server do |config|
  config.redis = config_redis
end

Sidekiq.configure_client do |config|
  config.redis = config_redis
end
