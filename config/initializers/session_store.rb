# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_drukarnia_session',
  :secret      => '854b6ef5e4fc25a3930d7f8c9cdfac6a6886593fd34699ecb5630dbc6af7d1760586f4c151e36c4a87c0bfe22789c117401239d84376354739c61d877b3b5622'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
