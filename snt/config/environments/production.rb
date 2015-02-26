Pms::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # Code is not reloaded between requests
  config.cache_classes = true

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Disable Rails's static asset server (Apache or nginx will already do this)
  config.serve_static_assets = false

  # Compress JavaScripts and CSS
  config.assets.compress = true

  # Compression algorithm for angular.js
  config.assets.js_compressor = Sprockets::LazyCompressor.new { Uglifier.new(mangle: false) }

  # Don't fallback to assets pipeline if a precompiled asset is missed
  config.assets.compile = false

  # Generate digests for assets URLs
  config.assets.digest = true

  # Defaults to nil and saved in location specified by config.assets.prefix
  # config.assets.manifest = YOUR_PATH

  # Specifies the header that your server uses for sending files
  # config.action_dispatch.x_sendfile_header = "X-Sendfile" # for apache
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # for nginx

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  # config.force_ssl = true

  # See everything in the log (default is :info)
  config.log_level = :debug

  # Prepend all log lines with the following tags
  # config.log_tags = [ :subdomain, :uuid ]

  # Use a different logger for distributed setups
  # config.logger = ActiveSupport::TaggedLogging.new(SyslogLogger.new)

  # Use a different cache store in production
  config.cache_store = :dalli_store, { expires_in: 1.day, compress: true }

  # Enable serving of images, stylesheets, and JavaScripts from an asset server
  # config.action_controller.asset_host = "http://assets.example.com"

  # Precompile additional assets (application.js, application.css, and all non-JS/CSS are already added)
  # QBurst : As in above comment Rails automatically add items in assets folder into asset pre-compilation.
  # In our case, we need to explicitly exclude node_modules and bower_components folders from pre-compiling.
  # Since Rails does not provide an exclude_tree mechanism, the below statement cancels the default action.
  # Hence, items added explicitly in this file or required in appropriate javascript files will only be served.
  config.assets.precompile = []

  config.assets.precompile += %w( .eot .woff .ttf admin/admin.css )
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

  # Enable threaded mode
  # config.threadsafe!

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify


  # Log the query plan for queries taking more than this (works
  # with SQLite, MySQL, and PostgreSQL)
  # config.active_record.auto_explain_threshold_in_seconds = 0.5

  # Set the logging destination(s)
  config.log_to = %w(file email)

  # Show the logging configuration on STDOUT
  config.show_log_configuration = false

  config.action_mailer.default_url_options = { host: 'https://pms.stayntouch.com' }
  config.action_mailer.asset_host = 'https://pms.stayntouch.com'
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.perform_deliveries = true
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.smtp_settings = YAML.load_file(File.open("#{Rails.root}/config/email.yml"))

  # To manage the UI team to work
  config.should_enforce_domain_restriction = false

  Paperclip::Attachment.default_options[:fog_directory] = 'ROVER'
  Paperclip::Attachment.default_options[:fog_host] = 'https://dc339bc8b8ac2711e720-e12599825d8179c6e5daa96e89bd97ed.ssl.cf2.rackcdn.com'

    # Set up to email the exception.
  config.middleware.use ExceptionNotification::Rack,
    :email => {
      :email_prefix => "[EXCEPTION]",
      :sender_address => %{"SNT ERROR NOTIFIER" <support@stayntouch.com>},
      :exception_recipients => %w{support@stayntouch.com jonathan@stayntouch.com}
  }
end
