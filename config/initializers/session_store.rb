# Configure the TorqueBox Servlet-based session store.
# Provides for server-based, in-memory, cluster-compatible sessions
if ENV['TORQUEBOX_APP_NAME']
  Webgrouper::Application.config.session_store :torquebox_store
else
  Webgrouper::Application.config.session_store :cookie_store, :key => '_WebgrouperdKasldkuo29404200+tdbpjwered_session'
end  
