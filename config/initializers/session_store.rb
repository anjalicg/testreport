# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_testreport_session',
  :secret      => 'a0e2309aafade2876b9b3d3b8e7ece4513e829840cb86db32fcac61526de48a9ba1025ca69bc3dbaae63326dc98ae5bc65f7692353843a8f32e3bc21a9fbe5f4'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
