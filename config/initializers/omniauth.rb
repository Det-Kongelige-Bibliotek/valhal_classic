Rails.application.config.middleware.use OmniAuth::Builder do

  provider :cas,
           :login_url => ADL::Application.config.cas[:login_url],
           :service_validate_url => ADL::Application.config.cas[:service_validate_url],
           :host => ADL::Application.config.cas[:host],
           :ssl => ADL::Application.config.cas[:ssl]
end

if ADL::Application.config.stub_authentication
  OmniAuth.config.test_mode = true
  OmniAuth.config.add_mock(:cas, {
      :uid => "username",
      :info => { :name => "Test User" },
      :extra => {
          :user => "username",
      }
  })
end

OmniAuth.config.logger = Rails.logger