# Configure the TorqueBox Servlet-based session store.
# Provides for server-based, in-memory, cluster-compatible sessions
if ENV['TORQUEBOX_APP_NAME']
  Rails.application.config.session_store TorqueBox::Session::ServletStore
else
  Rails.application.config.session_store :cookie_store, key: '_webgrouper_session'
end
