# -*- encoding : utf-8 -*-
require 'capybara/rspec'

Before('@omniauth_test') do
  OmniAuth.config.test_mode = true

  OmniAuth.config.add_mock(:ldap, {
      :provider => 'ldap',
      :host => 'thor.kb.dk',
      :base => 'DC=kb,DC=dk',
      :uid => 'sAMAccountName',
      :port => 389,
      :method => :plain,
      :info => {:name => 'Test User', :email => 'tester@kb.dk'}
  })

end

After('@omniauth_test') do
  OmniAuth.config.test_mode = false
end