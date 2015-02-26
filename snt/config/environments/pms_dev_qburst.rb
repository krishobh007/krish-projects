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

  config.cache_store = :dalli_store, { expires_in: 1.day, compress: true }

  # Set the logging destination(s)
  config.log_to = %w(file)

  # Show the logging configuration on STDOUT
  config.show_log_configuration = false

  # To manage the UI team to work
  config.should_enforce_domain_restriction = false
  config.log_to = %w(file)

  config.action_mailer.default_url_options = { host: 'http://localhost:3000/' }

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
    address: 'dev-tools.stayntouch.com',
    port: 25,
    domain: 'dev-tools.stayntouch.com',
    user_name: 'jenkins',
    password: '3tAyNt0uCh2013',
    enable_starttls_auto: false
 }

  Paperclip::Attachment.default_options[:fog_directory] = 'stayntouch_development'
  Paperclip::Attachment.default_options[:fog_host] = 'http://f61225b54a846bd532ec-fca1738d76525d3f0e1903a387dc915c.r72.cf1.rackcdn.com'

end
