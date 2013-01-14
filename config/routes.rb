# -*- encoding : utf-8 -*-
ADL::Application.routes.draw do
  resources :people

  resources :books

  devise_for :users

  root :to => "catalog#index"

  Blacklight.add_routes(self)
  HydraHead.add_routes(self)

  # The priority is based upon order of creation:
  # first created -> highest priority.

  #Standard resource mapping for Author
  resources :authors
  resources :upload
  resources :book_tei_representations
end
