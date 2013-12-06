require 'capybara/rails'
require 'capybara-webkit'
require 'omniauth'
require 'omniauth-ldap'
Capybara.javascript_driver = :webkit
Capybara.default_host = 'http://localhost:3000'