# -*- encoding : utf-8 -*-
#TODO: make class description
class ApplicationController < ActionController::Base
  # Adds a few additional behaviors into the application controller 
   include Blacklight::Controller  
# Adds Hydra behaviors into the application controller 
  include Hydra::Controller::ControllerBehavior

  # TODO: Please be sure to implement current_user and user_session. Blacklight depends on
  # these methods in order to perform user specific actions. 

  layout 'blacklight'

  protect_from_forgery
end
