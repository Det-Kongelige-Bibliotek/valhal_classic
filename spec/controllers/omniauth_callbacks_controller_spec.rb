require 'spec_helper'

describe OmniauthCallbacksController do

  it "should redirect to main page" do
    pending "need to figure out how to get around the tight omniauth integretion "
    get :ldap
    response.should be_succesful
  end

end
