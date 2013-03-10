source 'http://rubygems.org'

gem 'rails'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

# mongoDB driver
gem "mongoid"

gem 'json'

# Javascript-related:
gem 'jquery-rails', "~>2.1.0" #newer version break autocomplete!
gem 'jquery-ui-rails'
gem 'rails3-jquery-autocomplete', :git => "git://github.com/panmari/rails3-jquery-autocomplete.git"

# HTML Abstraction Markup Language 
# Templating Engine, that allows a non-repetitive and more elegant way to structure xhtml/xml with embedded ruby.
gem 'haml'
gem 'haml-rails'

# Prettier forms. Similar to formtastic, but lightweight.
gem 'simple_form'

# Complete validation of dates, times and datetimes for Rails 3.x and ActiveModel.
gem 'validates_timeliness'

# Wrapper around the Google Chart Tools that allows anyone to create the same beautiful charts with just plain Ruby
gem 'google_visualr'

# It’s a small library to provide the Rails I18n translations on Javascript.
gem "i18n-js"

# For retrieving gravatar pictures
gem 'gravatar_image_tag'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  gem 'therubyrhino'

  gem 'uglifier', '>= 1.0.3'
end

group :development do
  gem "torquebox-server"
end

group :test do
  gem 'test-unit'
  gem 'spork-rails'
  gem 'cucumber-rails'
  gem 'rspec-rails'
  gem 'database_cleaner'
  gem 'launchy'
  gem 'autotest-standalone'
  gem 'autotest-fsevent'
  gem 'autotest-growl'
end

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug'

group :deployment do
  gem "torquebox"
end
