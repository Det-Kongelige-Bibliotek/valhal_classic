source 'https://rubygems.org'

gem 'rails', '3.2.13'

gem "devise", "~> 2.1.2"
gem "blacklight"
gem 'hydra-head', '6.1.0'
gem 'sqlite3'
gem 'bootswatch-rails'
gem 'hydra-file_characterization'

gem 'jquery-rails'
gem 'client_side_validations'
gem 'uuid', '>= 2.3.6'

gem 'omniauth-ldap', '~> 1.0.4'
gem 'dynamic_form'
gem 'rubyzip'
#gem 'wicked' test comment

# Preservation
gem 'bunny', '~> 1.1.0'
gem 'amq-protocol', '>= 1.9.2'

# NOTE: the :require arg is necessary on Linux-based hosts
gem 'rmagick', '2.13.1', :require => 'RMagick'
gem 'paperclip'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails', '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'jquery-ui-rails'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  gem 'libv8', '~> 3.11.8'
  gem 'therubyracer', '0.11.1', :platforms => :ruby
  gem 'uglifier', '>= 1.0.3'
end

group :test do
  gem 'factory_girl_rails', '~> 4.1'
  gem 'capybara'
  gem 'rb-readline'
  gem 'simplecov-rcov'
  gem 'simplecov', :require => false
end

#gem 'rspec-rails', :group => [:development, :test]
#gem 'jettywrapper', :group => [:development, :test]
#gem 'thin', :group => [:development, :test]

group :development, :test do
  gem 'rspec-rails'
  gem 'jettywrapper'
  gem 'thin'
  gem 'cucumber-rails', :require => false
  gem 'database_cleaner'
  gem 'capybara'
  #gem 'capybara-webkit' uncomment if you want to run cucumber tests (cukes) in local dev environment.
end

group :development do
  gem 'better_errors'
  #Following gem has to be commented out if you want to debug Valhal in RubyMine
  gem 'debugger'
  gem 'equivalent-xml'
  gem 'jettywrapper'
  gem "binding_of_caller"
  gem 'guard-rspec'
  gem 'rb-inotify', :require => false
  gem 'rb-fsevent', :require => false
  gem 'rb-fchange', :require => false
  gem 'libnotify'
  gem 'listen'
end

gem "unicode", :platforms => [:mri_18, :mri_19]
gem "devise-guests", "~> 0.3"
gem "bootstrap-sass"

#logging
gem 'log4r', '1.1.9'
