class OmniauthCallbacksController < Devise::OmniauthCallbacksController
#  skip_before_filter :verify_authenticity_token

  def all
    user = User.from_omniauth(request.env["omniauth.auth"])

    if user.persisted?
      flash.notice = "Logged in as #{user.name}!"
      sign_in_and_redirect user
    else
      session["devise.user_attributes"] = user.attributes
      redirect_to new_user_registration_url
    end
  end

  alias_method :ldap, :all
end
