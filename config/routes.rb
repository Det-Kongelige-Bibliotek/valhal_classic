# -*- encoding : utf-8 -*-
ADL::Application.routes.draw do
  devise_for :users

  root :to => "catalog#index"

  Blacklight.add_routes(self)
  HydraHead.add_routes(self)

  # The priority is based upon order of creation:
  # first created -> highest priority.

  #Standard resource mapping
  resources :upload
  resources :book_tei_representations
  resources :book_tiff_representations
  resources :person_tei_representations
  resources :people
  resources :books
end
