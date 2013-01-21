# -*- encoding : utf-8 -*-
ADL::Application.routes.draw do
  devise_for :users

  root :to => "catalog#index"

  Blacklight.add_routes(self)
  HydraHead.add_routes(self)

  devise_for :users

  match '/login', :to => 'users/sessions#new', :as => 'new_user_session'
  match '/auth/:provider/callback', :to => 'users/sessions#create', :as => 'create_user_session'
  match '/logout', :to => 'users/sessions#destroy', :as => 'destroy_user_session'

  # The priority is based upon order of creation:
  # first created -> highest priority.

  #Standard resource mapping
  resources :upload
  resources :book_tei_representations
  resources :person_tei_representations
  resources :people
  resources :books
end
