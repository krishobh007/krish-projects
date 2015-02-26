Pms::Application.configure do
# Settings specified here will take precedence over those in config/application.rb

# In the development environment your application's code is reloaded on
# every request. This slows down response time but is perfect for development
# since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  config.serve_static_assets = true

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin

  # Raise exception on mass assignment protection for Active Record models
  config.active_record.mass_assignment_sanitizer = :strict

  # Log the query plan for queries taking more than this (works
  # with SQLite, MySQL, and PostgreSQL)
  config.active_record.auto_explain_threshold_in_seconds = 0.5

  # Do not compress assets
  config.assets.compress = false

  # Expands the lines which load the assets
  config.assets.debug = true

  config.cache_store = :dalli_store, { expires_in: 0.day, compress: true }

  # Set the logging destination(s)
  config.log_to = %w(stdout rolling_file)

  # Show the logging configuration on STDOUT
  config.show_log_configuration = false

  # To manage the UI team to work
  config.should_enforce_domain_restriction = false

  # Set up to email the exception.
  # config.middleware.use ExceptionNotification::Rack,
  # :email => {
    # :email_prefix => "[EXCEPTION]",
    # :sender_address => %{"SNT ERROR NOTIFIER" <no-reply@stayntouch.com>},
    # :exception_recipients => %w{ganesh@stayntouch.com}
  # }

  config.action_mailer.default_url_options = { host: 'http://localhost:3000' }
  config.action_mailer.asset_host = 'http://localhost:3000'
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.perform_deliveries = true
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.smtp_settings = YAML.load_file(File.open("#{Rails.root}/config/email.yml")) if File.exist?("#{Rails.root}/config/email.yml")

  # Allow test credit card numbers
  CreditCardValidator::Validator.options[:test_numbers_are_valid] = true
  Paperclip::Attachment.default_options[:fog_directory] = 'ROVER_DEV'
  Paperclip::Attachment.default_options[:fog_host] = 'https://c9fb255204921bbf6f41-821329d308ba0768463def967ad6e6e5.ssl.cf2.rackcdn.com'
end
