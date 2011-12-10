# Settings specified here will take precedence over those in config/environment.rb

# The production environment is meant for finished, "live" apps.
# Code is not reloaded between requests
config.cache_classes = true

# Full error reports are disabled and caching is turned on
config.action_controller.consider_all_requests_local = false
config.action_controller.perform_caching             = true
config.action_view.cache_template_loading            = true
config.action_mailer.default_url_options = { :host => 'drukarnia.megiteam.pl' }
 ActionMailer::Base.delivery_method = :smtp
  ActionMailer::Base.raise_delivery_errors = true
  ActionMailer::Base.default_charset = 'utf-8'
  ActionMailer::Base.smtp_settings = {
  :enable_starttls_auto => true,
  :address => 'drukarnia.megiteam.pl',
  :port => 25,
  :user_name => 'admin@drukarnia.megiteam.pl',
  :password => '',
  :domain => 'drukarnia.megiteam.pl',
  :authentication => :login }

# See everything in the log (default is :info)
# config.log_level = :debug

# Use a different logger for distributed setups
# config.logger = SyslogLogger.new

# Use a different cache store in production
# config.cache_store = :mem_cache_store

# Enable serving of images, stylesheets, and javascripts from an asset server
# config.action_controller.asset_host = "http://assets.example.com"

# Disable delivery errors, bad email addresses will be ignored
# config.action_mailer.raise_delivery_errors = false

# Enable threaded mode
# config.threadsafe!