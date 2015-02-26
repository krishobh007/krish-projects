Pms::Application.configure do

# In the development environment your application's code is reloaded on
# every request. This slows down response time but is perfect for development
# since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = true

  # TODO: Remove this line after email is configured correctly
  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

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

  # config.cache_store = :dalli_store,{:expires_in => 1.day, :compress => true }

  # Set the logging destination(s)
  config.log_to = %w(file)

  config.action_mailer.default_url_options = { host: 'http://calicut.qburst.in:8010' }
  config.action_mailer.asset_host = 'http://calicut.qburst.in:8010'

  # Show the logging configuration on STDOUT
  config.show_log_configuration = false

  # To manage the UI team to work
  config.should_enforce_domain_restriction = false

  # For testing mail service uncomment this line
  # ActionMailer::Base.delivery_method = :smtp
  # ActionMailer::Base.perform_deliveries = true
  # ActionMailer::Base.raise_delivery_errors = true
  ActionMailer::Base.delivery_method = :smtp
  ActionMailer::Base.perform_deliveries = true
  ActionMailer::Base.raise_delivery_errors = true

  ActionMailer::Base.smtp_settings = {
    address: 'smtp.gmail.com',
    port: 587,
    domain: 'gmail.com',
    user_name: 'rev2996',
    password: '9746602996',
    authentication: 'plain',
    enable_starttls_auto: true
  }

  Paperclip::Attachment.default_options[:fog_directory] = 'ROVER_DEV'
  Paperclip::Attachment.default_options[:fog_host] = 'http://9febeb11de6bb5e0ee62-821329d308ba0768463def967ad6e6e5.r41.cf2.rackcdn.com'

end
