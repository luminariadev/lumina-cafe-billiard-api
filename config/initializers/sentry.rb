Raven.configure do |config|
  config.dsn = ENV['SENTRY_DSN']
  config.environments = ['production', 'staging']
  config.current_environment = Rails.env
end
