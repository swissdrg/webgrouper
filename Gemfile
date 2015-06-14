source 'http://rubygems.org'
ruby "1.9.3", :engine => "jruby", :engine_version => "1.7.19"
#ruby=jruby-1.7.19

gem 'rails'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

# for newrelic monitoring
gem 'newrelic_rpm'

# mongoDB driver
gem 'mongoid'

# For seeding mongodb with icd/chop/drg
gem 'activerecord-jdbcpostgresql-adapter', require: false

# progress bar for visualizing progress of seeding
gem 'ruby-progressbar'

gem 'json'

# Javascript-related:
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'rails-jquery-autocomplete', git: 'https://github.com/panmari/rails-jquery-autocomplete.git'
# for date computation in JS
gem 'momentjs-rails'

# HTML Abstraction Markup Language 
# Templating Engine, that allows a non-repetitive and more elegant way tqo structure xhtml/xml with embedded ruby.
gem 'haml'
gem 'haml-rails'
gem 'slim'
gem "slim-rails"

# Prettier forms. Similar to formtastic, but lightweight.
gem 'simple_form'
# For easier building nested forms.
gem 'cocoon'

# Complete validation of dates, times and datetimes for Rails 3.x and ActiveModel.
gem 'validates_timeliness'

# Wrapper around the Google Chart Tools that allows anyone to create the same beautiful charts with just plain Ruby
gem 'google_visualr'

# It’s a small library to provide the Rails I18n translations on Javascript.
gem "i18n-js"

# For retrieving gravatar pictures
gem 'gravatar_image_tag'


# for webapi parsing
# 1.6.2.1 is buggy, see https://github.com/sparklemotion/nokogiri/issues/1114
gem 'nokogiri', '~>1.6.1.0'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  gem 'therubyrhino', platforms: :jruby

  gem 'uglifier', '>= 1.0.3'
  # For minifying css
  gem 'yui-compressor'
end


group :development do
  # For rubymine debug mode:
  gem 'ruby-debug-base'
  gem 'ruby-debug-ide'
end

group :test do
  gem 'theine'
  gem 'cucumber-rails', require: false
  gem 'selenium-webdriver'
  gem 'rspec-rails'
  # Version 1.4.0 causes issues: https://github.com/DatabaseCleaner/database_cleaner/issues/323
  gem 'database_cleaner', '< 1.4.0'
  gem 'capybara-webkit', platforms: :ruby
  gem 'launchy'
end

# For caching
gem 'dalli'
