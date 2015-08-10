require File.expand_path('../boot', __FILE__)

require "action_controller/railtie"
require "action_mailer/railtie"
require "rails/test_unit/railtie"
require "sprockets/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Webgrouper
  class Application < Rails::Application
    # Use dalli, a front end to memcached. Can be shared among rails instances. Takes about 0.35 s for grouping.
    # Configure cache, set maximum size of value to 10 MB.
    # This needs also to be set in /etc/memcached.conf by adding the following line:
    # -I 10m
    #config.cache_store = :dalli_store, { value_max_bytes: 10*1024*1024 }

    # If you want a faster cache that caches per-instance, use memory_store (about 0.05 s for grouping):
    config.cache_store = :memory_store, { size: 64.megabytes }

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Custom directories with classes and modules you want to be autoloadable.
    config.autoload_paths += %W(#{Rails.root}/app/models/validators #{Rails.root}/app/models/core)

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'Bern'

    # See http://stackoverflow.com/questions/20361428/rails-i18n-validation-deprecation-warning
    config.i18n.enforce_available_locales = false # we want to redirect to default locale

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    config.i18n.default_locale = :de

    # Do not swallow errors in after_commit/after_rollback callbacks.
    # config.active_record.raise_in_transactional_callbacks = true

    # Set timeliness to Euro.
    Timeliness.use_euro_formats
    # GC Profiling for newrelic.
    GC::Profiler.enable
    # Necessary for i18n-js to work.
    config.assets.initialize_on_precompile = true
  end
end
