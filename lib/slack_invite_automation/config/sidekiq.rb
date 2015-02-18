require 'sidekiq'
require 'dotenv'

Dotenv.load

redis_server = "redis://#{ ENV['REDIS_SERVER'] }/#{ ENV['REDIS_DB'] }"

Sidekiq.configure_server do |config|
  config.redis = { url: redis_server }
end

Sidekiq.configure_client do |config|
  config.redis = { url: redis_server }
end
