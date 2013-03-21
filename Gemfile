source 'https://rubygems.org'

gem 'rails', '3.2.11'

gem "devise", "~> 2.1.2"
gem "blacklight", "~> 4.0.1"
gem 'hydra-head', '5.4.0'
gem 'sqlite3'
gem 'bootswatch-rails'

gem 'jquery-rails'
gem 'client_side_validations'
gem 'uuid', '>= 2.3.6'

gem 'simplecov', :require => false, :group => :test
gem 'simplecov-rcov'
gem 'omniauth-ldap'
gem 'dynamic_form'
gem 'rubyzip'
gem 'wicked'

# NOTE: the :require arg is necessary on Linux-based hosts
gem 'rmagick', '2.13.1', :require => 'RMagick'
gem 'paperclip'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails', '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  gem 'libv8', '~> 3.11.8'
  gem 'therubyracer', '0.11.1', :platforms => :ruby
  gem 'uglifier', '>= 1.0.3'
end

group :test do
  gem 'factory_girl_rails', '~> 4.1'
  gem 'capybara'
  gem 'rb-readline'
end

gem 'rspec-rails' , :group => [:development, :test]

group :development do
  gem 'factory_girl_rails', '~> 4.1'
  gem 'better_errors'
  gem 'spork'
  gem 'debugger'
  gem 'equivalent-xml'
  gem 'jettywrapper', '>= 1.2.0'
  gem 'rb-inotify', '~> 0.8.8', :require => false
  gem 'guard-rspec'
  gem 'guard-livereload'
  gem 'guard-spork'
  gem 'thin'
end

gem "unicode", :platforms => [:mri_18, :mri_19]
gem "devise-guests", "~> 0.3"
gem "bootstrap-sass"

#logging
gem 'log4r', '1.1.9'
