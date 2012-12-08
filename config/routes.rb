# -*- encoding : utf-8 -*-
ADL::Application.routes.draw do
  devise_for :users

  root :to => "catalog#index"

  Blacklight.add_routes(self)


  # The priority is based upon order of creation:
  # first created -> highest priority.

  #Standard resource mapping for Author
  resources :authors

end
