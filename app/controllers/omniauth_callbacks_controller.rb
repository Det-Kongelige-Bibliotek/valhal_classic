class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  skip_before_filter :verify_authenticity_token

  def ldap
    puts "Yea"
    puts request.env["omniauth.auth"].to_yaml
  end

  def failure
    puts "Noo"
    puts request.env["omniauth.auth"].to_yaml
    super
  end


end
