# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_skillz_session',
  :secret      => '8225f7680879955c90689f7a78279cce31b4de8a94715ab5ea264fba5dbe044f7d6de312864f9dedf567b10eba96c88bcf4b20f714b5acf6106b6314c7b5a3dc'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
