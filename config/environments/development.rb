# Settings specified here will take precedence over those in config/environment.rb

# In the development environment your application's code is reloaded on
# every request.  This slows down response time but is perfect for development
# since you don't have to restart the webserver when you make code changes.
config.cache_classes = false

# Log error messages when you accidentally call methods on nil.
config.whiny_nils = true

# Show full error reports and disable caching
config.action_controller.consider_all_requests_local = true
config.action_view.debug_rjs                         = true
config.action_controller.perform_caching             = false

# Don't care if the mailer can't send
config.action_mailer.raise_delivery_errors = false

HOST = "localhost:3000"

GOOGLE_KEY='ABQIAAAAbUu9gzbumU80Yy5kUwAJXhTijmbmZEXGWcry6xYyCgVIR0KbURQRry4q0E2TQY22ORC7fs6IiQnLtQ'

config.action_mailer.default_url_options = { :host => HOST }

# Uncomment the following line if developing on a Mac
Paperclip.options[:command_path] = "/usr/local/bin/"
# Uncomment the following line for debugging Paperclip
#Paperclip.options[:swallow_stderr] = false

# Proxy settings
PROXY_HOST = nil
PROXY_PORT = nil
PAPERCLIP_S3_OPTS = nil
