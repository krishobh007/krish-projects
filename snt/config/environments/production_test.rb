Pms::Application.configure do
# config.force_ssl = true

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

  # Disable Rails's static asset server (Apache or nginx will already do this)
  config.serve_static_assets = false

  # Compress assets
  config.assets.compress = true

  # Compression algorithm for angular.js
  config.assets.js_compressor = Sprockets::LazyCompressor.new { Uglifier.new(mangle: false) }

  # Don't fallback to assets pipeline if a precompiled asset is missed
  config.assets.compile = false

  # Generate digests for assets URLs
  config.assets.digest = true

  # Expands the lines which load the assets
  config.assets.debug = true

  # Precompile additional assets (application.js, application.css, and all non-JS/CSS are already added)

  # QBurst : As in above comment Rails automatically add items in assets folder into asset pre-compilation.
  # In our case, we need to explicitly exclude node_modules and bower_components folders from pre-compiling.
  # Since Rails does not provide an exclude_tree mechanism, the below statement cancels the default action.
  # Hence, items added explicitly in this file or required in appropriate javascript files will only be served.
  config.assets.precompile = []

  config.assets.precompile += %w( *.eot *.woff *.ttf admin/admin.css )
  config.assets.precompile += %w(*.png *.jpg *.jpeg *.gif)
  config.assets.precompile += %w(*.json)
  config.assets.precompile += %w(*.html)
  config.assets.precompile += %w( application.css )
  config.assets.precompile += %w( application.js )

  config.assets.precompile += %w( cordova.js )
  config.assets.precompile += %w( cordova_plugins.js )

  config.assets.precompile += %w( guestweb.js )
  config.assets.precompile += %w( guestweb.css )

  config.assets.precompile += %w( guestweb_yotel.js )
  config.assets.precompile += %w( guestweb_yotel.css )

  config.assets.precompile += %w( guestweb_galleria.js )
  config.assets.precompile += %w( guestweb_galleria.css )

  config.assets.precompile += %w( staff_housekeeping.js )
  config.assets.precompile += %w( staff_housekeeping.css )

  config.assets.precompile += %w( admin_main.js )
  config.assets.precompile += %w( admin_main.css )
  config.assets.precompile += %w( login.js )

  config.assets.precompile += %w( reports.js )

  config.assets.precompile += %w( staff_main.js )
  config.assets.precompile += %w( staff_main.css )

  config.assets.precompile += %w( admin_templates.js )
  config.assets.precompile += %w( rover_templates.js )

  config.assets.precompile += %w( guestweb_fontainebleau.js )
  config.assets.precompile += %w( guestweb_fontainebleau.css )

  config.assets.precompile += %w( guestweb_nikko.js )
  config.assets.precompile += %w( guestweb_nikko.css )

  config.assets.precompile += %w( guestweb_mgm.js )
  config.assets.precompile += %w( guestweb_mgm.css )

  config.assets.precompile += %w( guestweb_eden.js )
  config.assets.precompile += %w( guestweb_eden.css )

  config.assets.precompile += %w( guestweb_huntley.js )
  config.assets.precompile += %w( guestweb_huntley.css )


  config.cache_store = :dalli_store, { expires_in: 1.day, compress: true }

  config.log_level = :debug

  # Set the logging destination(s)
  config.log_to = %w(file email)

  # Show the logging configuration on STDOUT
  config.show_log_configuration = false

  config.action_mailer.default_url_options = { host: 'https://pms-prod-test.stayntouch.com' }
  config.action_mailer.asset_host = 'https://pms-prod-test.stayntouch.com'
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.perform_deliveries = true
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.smtp_settings = YAML.load_file(File.open("#{Rails.root}/config/email.yml"))

  # To manage the UI team to work
  config.should_enforce_domain_restriction = false
  
  # Allow test credit card numbers
  CreditCardValidator::Validator.options[:test_numbers_are_valid] = true

  Paperclip::Attachment.default_options[:fog_directory] = 'ROVER_STAGING'
  Paperclip::Attachment.default_options[:fog_host] = 'https://8ebd8b3dcdf6d6f8887d-4d1e022461cbaa577307930af1386d20.ssl.cf2.rackcdn.com'
end
