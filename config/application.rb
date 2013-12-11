# -*- encoding : utf-8 -*-
require File.expand_path('../boot', __FILE__)



require 'rails/all'
require 'log4r'
require 'log4r/yamlconfigurator'
require 'log4r/outputter/datefileoutputter'
include Log4r

if defined?(Bundler)
  # If you precompile assets before deploying to production, use this line
  puts "RAILS_ENV=#{Rails.env.to_s}"
  Bundler.require(*Rails.groups(:assets => %w(development test)))
  Bundler.require(*Rails.groups(:debug => %w(development)))
  # If you want your assets lazily compiled in production, use this line
  # Bundler.require(:default, :assets, Rails.env)
end

def recursive_symbolize_keys! hash
  hash.symbolize_keys!
  hash.values.select{|v| v.is_a? Hash}.each{|h| recursive_symbolize_keys!(h)}
end

# Load the local ldap configuration
begin
  CONFIG = YAML.load(File.read(File.expand_path('../application.local.yml', __FILE__)))
  CONFIG.merge! CONFIG.fetch(Rails.env, {})
  recursive_symbolize_keys! CONFIG
rescue => error
  puts "Couldn't load the basic_files 'application.local.yml': #{error.inspect.to_s}"
  CONFIG = {:ldap => {:user => 'sifd-ldap-read', :password => ''}, :test=>{:user=>'sifdtest', :password=>''}}
end

module Valhal
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into basic_files in config/initializers
    # -- all .rb basic_files in that directory are automatically loaded.
    config.application_name = "SIFD"
    # Custom directories with classes and modules you want to be autoloadable.
    # config.autoload_paths += %W(#{config.root}/extras)
    config.autoload_paths += Dir[Rails.root.join('app', 'models', 'datastreams', '{**}')]
    config.autoload_paths += Dir[Rails.root.join('app', 'helpers', 'constants.rb')]

    # Only load the plugins named here, in the order given (default is alphabetical).
    # :all can be used as a placeholder for all plugins not explicitly named.
    # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

    # Activate observers that should always be running.
    # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    # Configure sensitive parameters which will be filtered from the log basic_files.
    config.filter_parameters += [:password]

    #forces ssl to be turned on for all sites, requires the web server to have been setup for ssl/tls
    #config.force_ssl = true

    # Enable escaping HTML in JSON.
    config.active_support.escape_html_entities_in_json = true

    # Use SQL instead of Active Record's schema dumper when creating the database.
    # This is necessary if your schema can't be completely dumped by the schema dumper,
    # like if you have constraints or database-specific column types
    # config.active_record.schema_format = :sql

    # Enforce whitelist mode for mass assignment.
    # This will create an empty whitelist of attributes available for mass-assignment for all models
    # in your app. As such, your models will need to explicitly whitelist or blacklist accessible
    # parameters by using an attr_accessible or attr_protected declaration.
    config.active_record.whitelist_attributes = true

    # Enable the asset pipeline
    config.assets.enabled = true
    # Default SASS Configuration, check out https://github.com/rails/sass-rails for details
    config.assets.compress = !Rails.env.development?

    # Config to be overriden by local settings
    config.stub_authentication = false

    # Version of your assets, change this if you want to expire all your assets
    config.assets.version = '1.0'



    log4r_config = YAML.load_file(File.join(File.dirname(__FILE__),"log4r.yml"))
    YamlConfigurator.decode_yaml( log4r_config['log4r_config'] )
    config.logger = Log4r::Logger[Rails.env]
  end
end
