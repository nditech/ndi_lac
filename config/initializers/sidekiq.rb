redis_config = YAML.load_file(File.expand_path('../../redis.yml', __FILE__))
environment = defined?(Rails) ? Rails.env : ENV['RAILS_ENV']
environment_config = redis_config[environment]

Sidekiq.configure_server do |config|
  url = "redis://#{environment_config['host']}:#{environment_config['port']}/0"
  config.redis = { url: url}
end

Sidekiq.configure_client do |config|
  url = "redis://#{environment_config['host']}:#{environment_config['port']}/0"
  config.redis = { url: url}
end